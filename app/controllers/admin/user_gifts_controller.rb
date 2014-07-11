class Admin::UserGiftsController < AdminController
  authorize_resource

  def index
    @user_gifts = UserGift.all.order(id: :desc)
  end

  def check
    @payments = Payment.where(canceled: false, completed: false).where.not(user_gift_id: '', amount: 0, pay_time: nil)
  end

  def check_show
    @payment = Payment.find_by_user_gift_id(params[:id])

    locale = Locale.find(@payment.user_gift.locale_id)
    I18n.locale = locale.lang

    @user_gift = @payment.user_gift
  end

  def show
    @user_gift = UserGift.find(params[:id])
  end
end
