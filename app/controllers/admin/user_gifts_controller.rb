class Admin::UserGiftsController < AdminController
  authorize_resource

  def index
    @user_gifts = UserGift.all.order(id: :desc)
  end

  def check
    @payments = Payment.where(canceled: false).where.not(user_gift_id: '', completed: true)
  end

  def check_show
    @payment = Payment.where(user_gift_id: params[:id]).first
  end

  def show

  end
end
