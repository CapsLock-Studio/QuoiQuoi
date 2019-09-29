class Admin::UserGiftsController < AdminController
  authorize_resource

  def index
    @event_gifts = UserGift.includes(:user_gift_payment)
                       .where({ payment_method: UserGift.payment_methods[:event] })
                       .where.not(user_gift_payments: {id: nil})
                       .order(id: :desc)

    @user_gifts = UserGift.includes(:user_gift_payment)
                      .where.not({ payment_method: UserGift.payment_methods[:event] })
                      .where.not(user_gift_payments: {id: nil})
                      .order(id: :desc)
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

  def new
    @user_gift = UserGift.new
  end

  def create
    user_gift = UserGift.create(
        {
            gift_id: params[:gift_id],
            quantity: params[:quantity],
            payment_method: UserGift.payment_methods[:event],
        }
    )

    UserGiftPayment.create(
        {
            user_gift_id: user_gift.id,
            completed: true,
            completed_time: Time.now,
            payment_time: Time.now,
        }
    )

    redirect_to action: :index
  end
end
