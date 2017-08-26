class UserGiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_gift, except: [:index, :search]
  before_action :set_user_gift_serial_by_serial, only: [:search, :discount]

  skip_before_action :verify_authenticity_token, only: [:update, :return]

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

  def send_email
    flash[:message] = t('mailer.success')
    flash[:status] = 'success'
    UserGiftMailer.send_to_other(params[:user_gift_serial_id], params[:email]).deliver

    render action: :show
  end

  def create
    redirect_to controller: :user_gift_payment, action: UserGift.new(user_gift_params).payment_method, params: params
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

  def return
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.in_trading'), :orders_path
    add_breadcrumb t('detail')

    @user_gift = UserGift.find(params['MerchantTradeNo'].delete('G').split('t')[0])

    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_completed')

      # Not really update order entity, just show the newest status.
      @user_gift.user_gift_payment.trade_no = params['TradeNo']
      @user_gift.user_gift_payment.trade_time = params['TradeDate']
      @user_gift.user_gift_payment.payment_time = params['PaymentDate']
      @user_gift.user_gift_payment.completed =  true
      @user_gift.user_gift_payment.completed_time = Time.now

      @user_gift.user_gift_payment.save!

      UserGiftMailer.completed_confirmation(@user_gift.id).deliver_later
    else
      errorCodes = JSON.parse(File.read('app/assets/javascripts/ecpayErrorCodes.json'))

      flash.now[:icon] = 'fa-exclamation-triangle'
      flash.now[:status] = 'danger'
      flash.now[:message] = "#{t('error_code')}: #{params['RtnCode']}, #{errorCodes[params['RtnCode']]} 🚫 #{t('payment_failed')}"
    end

    render 'user_gifts/show'
  end
  
  def payment
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')
    add_breadcrumb t('check_out')

    @user_gift = Gift.includes(:gift_translate)
                        .where(gift_translates: {locale_id: session[:locale_id]}, id: user_gift_params[:gift_id])
                        .first
                        .user_gifts.build(user_gift_params)

    @user_gift.locale_id = session[:locale_id]
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

          UserGiftMailer.used_remind(@user_gift_serial.id).deliver

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

  def destroy
    if @user_gift.destroy
      redirect_to :back
    else
      render json: @user_gift.errors
    end
  end

  private
    def user_gift_params
      params.require(:user_gift).permit(:id, :gift_id, :quantity, :payment_method)
    end

    def set_user_gift
      @user_gift = UserGift.where(id: params[:id], user_id: current_user.id).first
    end

    def set_user_gift_serial_by_serial
      @user_gift_serial = UserGiftSerial.find_by_serial(params[:serial])
    end

    def redirect_to_order_or_registration
      if !params[:order_id].blank?
        redirect_to pay_order_path(params[:order_id])
      elsif !params[:registration_id].blank?
        redirect_to pay_registration_path(params[:registration_id])
      end
    end
end