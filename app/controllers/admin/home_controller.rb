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
              Order.where('created_at > ? AND created_at <= ?', date, date + 1.days).size
          ]

          @new_user_each_day << [
              date.to_time.to_i * 1000,
              User.where('created_at > ? AND created_at <= ? AND name != ?', date, date + 1.days, 'guest').size
          ]
        end

        render json: {order_quantity_each_day: @order_quantity_each_day, new_user_each_day: @new_user_each_day}
      }

      format.html {
        @order = {
            remittance_report_wait_confirm: OrderRemittanceReport.where(confirm: nil).size,
            wait_deliver: Order.includes(:order_payment).where(order_payments: {completed: true}, delivered: false).size,
            shipping_problem_not_solved: Order.includes(:order_payment).where(order_payments: {completed: true},
                                                                              delivered: true,
                                                                              delivery_report: true,
                                                                              delivery_report_handled: false).size,
            archived_this_week: Order.where(closed: true).where('closed_time > ? AND closed_time <= ?', Date.today.at_beginning_of_week, Date.today).size
        }

        @custom_order = {
            discussing: CustomOrder.where(approve: nil).size
        }

        @registration = {
            remittance_report_wait_confirm: '1'
        }
      }
    end
  end
end
