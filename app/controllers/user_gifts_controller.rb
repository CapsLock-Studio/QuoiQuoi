class UserGiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_gift, except: [:index, :search]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('my_gift'), :user_gifts_path

    @user_gifts = UserGift.where(user_id: current_user.id)
  end

  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('my_gift'), :user_gifts_path
    add_breadcrumb t('detail')

    if @user_gift.payment && @user_gift.payment.completed? && @user_gift.token.blank?
      @user_gift.token = get_uniqueness_random_string
      unless @user_gift.save
        render json: @user_gift.errors
      end
    end
  end

  def create

    @user_gift = UserGift.new(user_gift_params.merge({user_id: current_user.id}))
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
    begin
      set_user_gift_by_token
    rescue ActiveRecord::RecordNotFound
      render json: 'test'
    end
  end

  def discount
    set_user_gift_by_token
    if @user_gift
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

        discount_item.subtotal -= @user_gift.gift.quota

        if discount_item.subtotal < 0
          discount_item.subtotal = 0
        end

        @user_gift.used_time = Time.now
        @user_gift.used_user_id = current_or_guest_user.id

        discount_item.save!
        @user_gift.save!

        flash[:message] = t('user_gift.success')

        redirect_to discount_item

      rescue ActiveRecord::RecordNotFound
        render json: 'Discount item not found, please restart your work.'
      end

    else
      render json: 'Gift card not found error', status: 403
    end
  end

  private
    def user_gift_params
      params.require(:user_gift).permit(:id, :gift_id)
    end

    def set_user_gift
      @user_gift = UserGift.where(id: params[:id], user_id: current_user.id).first
    end

    def set_user_gift_by_token
      @user_gift = UserGift.find_by_token(params[:token])
    end

    def get_uniqueness_random_string
      uniqueness_random_string = SecureRandom.hex(20)
      while UserGift.where(token: uniqueness_random_string).first
        uniqueness_random_string = SecureRandom.hex(20)
      end

      uniqueness_random_string
    end
end