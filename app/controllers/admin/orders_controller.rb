class Admin::OrdersController < AdminController
  authorize_resource
  before_action :set_order, only: [:edit, :show, :update]
  before_action :set_shipping_fee, only: [:edit, :show]
  before_action :set_discount, only: [:edit, :show]
  add_breadcrumb '首頁', :admin_root_path

  # GET /admin/orders
  # GET /admin/orders.json
  def index
    @orders = Order.includes(:order_payment).where(order_payments: {completed: [true, false]})

    unless search_filter_params.nil?
      @search_filter = search_filter_params
      conditions = search_filter_params

      # Unless the completed_time is not nil, translate it to date range for rails.
      unless conditions['order_payments']['completed_time'].nil?
        dates = conditions['order_payments']['completed_time'].split(' - ')
        conditions['order_payments']['completed_time'] = dates[0]..dates[1]
      end

      # Unless the delivered_time is not nil, translate it to date range for rails.
      unless conditions['delivered_time'].nil?
        dates = conditions['delivered_time'].split(' - ')
        conditions['delivered_time'] = dates[0]..dates[1]
      end

      # Unless the closed_time is not nil, translate it to date range for rails.
      unless conditions['closed_time'].nil?
        dates = conditions['closed_time'].split(' - ')

        # Including not archived items.
        conditions['closed_time'] = [dates[0]..dates[1], nil]
      end

      @orders = @orders.where(conditions)
    end
  end

  # GET /admin/orders/canceled
  def canceled
    @orders = Order.includes(:order_payment).where(order_payments: {cancel: true})

    unless cancel_search_filter_params.nil?
      @search_filter = cancel_search_filter_params
      conditions = cancel_search_filter_params

      unless conditions['cancel_time'].nil?
        dates = conditions['cancel_time'].split(' - ')
        conditions['cancel_time'] = dates[0]..dates[1]

        # Add search conditions to orders
        @orders = @orders.where(order_payments: conditions)
      end
    end
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

  def edit
    add_breadcrumb '待出貨訂單', :deliver_admin_orders_path
    add_breadcrumb '訂單詳細內容'
  end

  def deliver
    @orders = Order.includes(:order_payment).where(order_payments: {completed: true}, closed: false)
  end

  def archive
    @search_filter = archive_search_filter_params || Order.payment_methods.map{|payment_method| payment_method[1]}

    @orders = Order.includes(:order_payment).where(order_payments: {completed: true}, closed: true, payment_method: @search_filter)
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
    if Order.find(params[:id]).destroy!
      redirect_to canceled_admin_orders_path
    end

    flash[:id] = params[:id]
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

  def archive_search_filter_params
    (params[:search_filter].nil?)? params[:search_filter] : params[:search_filter].map{|value| value.to_i}
  end

  def cancel_search_filter_params
    unless params[:search_filter].nil?
      sanitize_params = params[:search_filter].permit(:cancel_time)
      sanitize_params.delete('cancel_time') if sanitize_params['cancel_time'].blank?
      sanitize_params
    end
  end

  def search_filter_params
    unless params[:search_filter].nil?
      sanitize_params = params[:search_filter].permit(:delivered_time, :closed, :closed_time,
                                                      order_payments: [{completed: []}, :completed_time],
                                                      payment_method: [],
                                                      delivered: [])
      sanitize_params['payment_method'] = sanitize_params['payment_method'].map{|value| value.to_i} unless sanitize_params['payment_method'].nil?
      sanitize_params['order_payments'].delete('completed_time') if sanitize_params['order_payments']['completed_time'].blank?
      sanitize_params.delete('delivered_time') if sanitize_params['delivered_time'].blank?

      if sanitize_params['closed'].nil?
        sanitize_params['closed'] = false
      else
        sanitize_params.delete('closed')
        sanitize_params.delete('closed_time') if sanitize_params['closed_time'].blank?
      end

      sanitize_params
    end
  end
end
