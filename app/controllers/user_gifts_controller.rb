class UserGiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_gift, except: [:index, :search]
  before_action :set_user_gift_serial_by_serial, only: [:search, :discount]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('my_gift'), :user_gifts_path

    flash[:message] = nil

    @user_gifts = UserGift.where(user_id: current_user.id)
  end

  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('my_gift'), :user_gifts_path
    add_breadcrumb t('detail')

    flash[:message] = nil
  end

  def new
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('gift'), gifts_path
    add_breadcrumb t('check_out')

    flash[:message] = nil

    @user_gift = UserGift.new(user_gift_params)
  end

  def send_email
    flash[:message] = t('mailer.success')
    flash[:status] = 'success'
    UserGiftMailer.send_to_other(params[:user_gift_serial_id], params[:email]).deliver

    render action: :show
  end

  def create

    locale = Locale.find(session[:locale_id])
    @user_gift = UserGift.new(user_gift_params.merge({user_id: current_user.id}))
    @user_gift.currency = locale.currency
    @user_gift.locale_id = locale.id

    respond_to do |format|
      if @user_gift.save
        format.html {redirect_to pay_user_gift_path(@user_gift)}
      else
        format.html {redirect_to gift_path(@user_gift.gift)}
      end
    end
  end

  def update
    respond_to do |format|
      if !@user_gift.payment || !@user_gift.payment.completed?
        format.html {redirect_to action: :show}
      elsif @user_gift.update_attribute(:token, SecureRandom.hex(20))
        format.html {render action: :show}
      else
        format.html {render json: @user_gift.errors}
      end
    end
  end

  def pay_show

    #respond_to do |format|
    #  format.html {render json: @user_gift.gift.gift_translates.where(locale_id: session[:locale_id])}
    #end

    if @user_gift.payment && @user_gift.payment.completed?
      redirect_to user_gift_path(@user_gift)
    elsif @user_gift.payment
      @user_gift.payment.destroy
      @payment = @user_gift.build_payment
    else
      @payment = @user_gift.build_payment
    end
  end

  def search

  end

  def discount
    if @user_gift_serial
      if @user_gift_serial.used_time
        flash[:message] = t('user_gift.oops')
        flash[:status] = 'warning'

        redirect_to_order_or_registration
      else
        discount_item = nil

        UserGiftMailer.used_remind(@user_gift_serial.user_gift_id).deliver

        begin
          unless params[:order_id].blank?
            discount_item = Order.find(params[:order_id])
          end

          unless params[:registration_id].blank?
            discount_item = Registration.find(params[:registration_id])
          end

          unless discount_item
            raise ActiveRecord::RecordNotFound
          end

          gift_translate = GiftTranslate.where(gift_id: @user_gift_serial.user_gift.gift_id, locale_id: discount_item.locale_id).first
          discount_item.subtotal -= gift_translate.quota

          if discount_item.subtotal <= 0
            discount_item.subtotal = 0
          else
            flash[:message] = t('user_gift.success')
          end

          @user_gift_serial.used_time = Time.now
          @user_gift_serial.order_id = params[:order_id]

          if discount_item.user
            @user_gift_serial.email = discount_item.user.email
          else
            @user_gift_serial.email = discount_item.email
          end

          @user_gift_serial.registration_id = params[:registration_id]

          discount_item.save!
          @user_gift_serial.save!

          if discount_item.subtotal == 0
            payment = discount_item.build_payment(token: Base64.encode64("#{Time.now}#{(0..3).map{('a'..'z').to_a[rand(26)]}.join}"), user_id: current_user.id, order_id: params[:order_id], registration_id: params[:registration_id], completed: true, currency: discount_item.currency, pay_time: Time.now, amount: 0)

            if payment.save
              if payment.order

                # send mail to remind order complete
                OrderMailer.remind(payment.order_id).deliver

                flash[:status] = 'success'
                flash[:message] = t('completed_payment')

                redirect_to order_path(params[:order_id])
              elsif payment.registration

                # send mail to remind registration
                RegistrationMailer.remind(payment.registration_id).deliver

                # show the message let users know their payment complete
                flash[:status] = 'success'
                flash[:message] = t('completed_payment')

                if payment.registration.user
                  redirect_to course_path(payment.registration.course)
                else
                  redirect_to action: :show
                end
              end
            else
              format.html {render json: @payment.errors}
            end
          else
            flash[:status] = 'success'
            flash[:message] = t('user_gift.success')

            redirect_to_order_or_registration
          end

        rescue ActiveRecord::RecordNotFound
          render json: 'Discount item not found, please restart your work.'
        end
      end
    else
      flash[:message] = t('user_gift.sorry')
      flash[:status] = 'warning'

      redirect_to_order_or_registration
    end
  end

  private
    def user_gift_params
      params.require(:user_gift).permit(:id, :gift_id, :quantity)
    end

    def set_user_gift
      @user_gift = UserGift.where(id: params[:id], user_id: current_user.id).first
    end

    def set_user_gift_serial_by_serial
      @user_gift_serial = UserGiftSerial.find_by_serial(params[:serial])
    end

    def get_uniqueness_random_string
      uniqueness_random_string = SecureRandom.hex(20)
      while UserGift.where(token: uniqueness_random_string).first
        uniqueness_random_string = SecureRandom.hex(20)
      end

      uniqueness_random_string
    end

    def redirect_to_order_or_registration
      if !params[:order_id].blank?
        redirect_to pay_order_path(params[:order_id])
      elsif !params[:registration_id].blank?
        redirect_to pay_registration_path(params[:registration_id])
      end
    end
end