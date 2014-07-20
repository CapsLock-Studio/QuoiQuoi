class Admin::HomeController < AdminController
  authorize_resource :admin

  # GET /admin
  def index
    respond_to do |format|
      format.json {
        @order_quantity_each_day = []
        @new_user_each_day = []
        2.month.ago.to_date.step( DateTime.now ).to_a.each do |date|
          @order_quantity_each_day << [
              date.to_time.to_i * 1000,
              Order.distinct.count(conditions: ['created_at > ? AND created_at <= ?', date, date + 1.day])
          ]

          @new_user_each_day << [
              date.to_time.to_i * 1000,
              User.distinct.count(conditions: ['created_at > ? AND created_at <= ? AND name != ?', date, date + 1.day, 'guest'])
          ]
        end

        render json: {order_quantity_each_day: @order_quantity_each_day, new_user_each_day: @new_user_each_day}
      }

      format.html {
        @order_wait_confirm_remittance = Payment.where(completed: false).where.not(order_id: '', amount: 0, pay_time: nil).reject{|payment| !payment.order}.count
        @order_pre_shipping = Payment.where(completed: true).where.not(order_id: ['', nil]).count
        @closed_order = Order.where(checkout: true, canceled: false, closed: true).count
        @custom_order_wait_confirm = OrderCustomItem.where(canceled: false, accept: nil, accept_time: nil).where.not(user_id: ['', nil]).count
        @registration_wait_confirm_remittance = Payment.where(canceled: false, completed: false).where.not(registration_id: '', amount: 0, pay_time: nil).count
        @user_gift__wait_confirm_remittance = Payment.where(canceled: false, completed: false).where.not(user_gift_id: '', amount: 0, pay_time: nil).count
      }
    end
  end
end
