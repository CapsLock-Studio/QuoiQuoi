class Admin::OrdersController < AdminController
  authorize_resource
  before_action :set_order, only: [:edit, :show, :update]
  before_action :set_shipping_fee, only: [:edit, :show]
  before_action :set_discount, only: [:edit, :show]
  add_breadcrumb '首頁', :admin_root_path

  # GET /admin/orders
  # GET /admin/orders.json
  def index
    add_breadcrumb '訂單記錄'
    @orders = Order.where(checkout: true, canceled: false)
  end

  # GET /admin/orders/canceled
  def canceled
    add_breadcrumb '已取消訂單'
    @orders = Order.where(checkout: true, canceled: true)
  end

  def closed
    @orders = Order.where(checkout: true, canceled: false, closed: true)
  end

  # GET /admin/orders/1
  # GET /admin/orders/1.json
  def show
    add_breadcrumb '訂單記錄', :admin_orders_path
    add_breadcrumb '訂單詳細內容'
  end

  # GET /admin/orders/new
  def new

  end

  def edit
    add_breadcrumb '待出貨訂單', :deliver_admin_orders_path
    add_breadcrumb '訂單詳細內容'
  end

  def deliver
    # @orders = []
    # Payment.where(completed: true).where.not(order_id: ['', nil]).each do |payment|
    #   if payment.order && !payment.order.closed?
    #     @orders << payment.order
    #   end
    # end

    @orders = Order.includes(:order_payment).where(order_payments: {completed: true}, closed: false)
  end

  def archive
    @search_filter = search_filter_params || Order.payment_methods.map{|payment_method| payment_method[1]}

    @orders = Order.includes(:order_payment).where(order_payments: {completed: true}, closed: true, payment_method: @search_filter)
  end

  # POST /admin/orders
  # POST /admin/orders.json
  def create

  end

  # PATCH/PUT /admin/orders/1
  # PATCH/PUT /admin/orders/1.json
  def update
    if order_params[:closed]
      @order.closed = true
      @order.closed_time = Time.now
    elsif order_params[:delivery_report_handled]
      @order.delivery_report_handled = true
      @order.delivery_report_handled_time = Time.now
    elsif order_params[:delivered]
      @order.delivered = true
      @order.delivered_time = Time.now
    end

    @order.save!

    flash[:id] = @order.id
    flash[:closed] = order_params[:closed]
    flash[:delivery_report_handled] = order_params[:delivery_report_handled]
    flash[:delivered] = order_params[:delivered]

    redirect_to action: :deliver
  end

  # DELETE /admin/orders/1
  # DELETE /admin/orders/1.json
  def destroy

  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_shipping_fee
    @shipping_fee = ShippingFeeTranslate.where(locale_id: @order.locale_id, shipping_fee_id: @order.shipping_fee_id).first
    if @shipping_fee.free_condition && @order.subtotal >= @shipping_fee.free_condition
      @shipping_fee.fee = 0
    end
  end

  def set_discount
    @discount = 0
    UserGiftSerial.where(order_id: @order.id).each do |user_gift_serial|
      @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @order.locale_id).first.quota
    end
  end

  def order_params
    params.permit(:closed, :delivery_report_handled, :delivered)
  end

  def search_filter_params
    (params[:search_filter].nil?)? params[:search_filter] : params[:search_filter].map{|value| value.to_i}
  end
end
