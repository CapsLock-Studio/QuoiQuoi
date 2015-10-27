class Admin::OrderPaymentsController < AdminController
  before_action :set_order_payment, only: [:show, :update]

  def show
    render layout: false
  end

  def update
    if sanitize_params[:cancel]
      @order_payment.cancel = true
      @order_payment.cancel_time = Time.now
      @order_payment.cancel_reason = sanitize_params[:cancel_reason]

      @order_payment.save!

      flash[:id] = @order_payment.order.id
      flash[:status] = sanitize_params

      redirect_to admin_orders_path
    end
  end

  private
  def set_order_payment
    @order_payment = OrderPayment.find(params[:id])
  end

  def sanitize_params
    params.permit(:cancel, :cancel_reason)
  end
end
