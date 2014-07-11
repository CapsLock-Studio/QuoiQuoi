class Admin::OrdersController < AdminController
  authorize_resource
  before_action :set_order, only: [:check_show, :edit, :show, :update]
  before_action :set_shipping_fee, only: [:check_show, :edit, :show]
  before_action :set_discount, only: [:check_show, :edit, :show]
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

  def check
    @payments = Payment.where(completed: false).where.not(order_id: '', amount: 0, pay_time: nil).reject{|payment| !payment.order}
  end

  def check_show
    add_breadcrumb '待確認匯款訂單列表', :check_admin_orders_path

    @payment = Payment.where(order_id: params[:id]).first
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
    @orders = []
    Payment.where(completed: true).where.not(order_id: ['', nil]).each do |payment|
      if payment.order && !payment.order.closed?
        @orders << payment.order
      end
    end
  end

  # POST /admin/orders
  # POST /admin/orders.json
  def create

  end

  # PATCH/PUT /admin/orders/1
  # PATCH/PUT /admin/orders/1.json
  def update
    respond_to do |format|
      if @order.update_attributes({delivered: true, delivered_time: Time.now})
        OrderMailer.delivered(@order.id).deliver
        format.html {redirect_to deliver_admin_orders_path}
      else
        format.html {render json: @order.errors}
      end
    end
  end

  # DELETE /admin/orders/1
  # DELETE /admin/orders/1.json
  def destroy

  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def set_shipping_fee
      @shipping_fee = ShippingFeeTranslate.where(locale_id: @order.locale_id, shipping_fee_id: @order.shipping_fee_id).first
      if @shipping_fee.free_condition && @order.subtotal > @shipping_fee.free_condition
        @shipping_fee.fee = 0
      end
    end

    def set_discount
      @discount = 0
      UserGiftSerial.where(order_id: @order.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @order.locale_id).first.quota
      end
    end
end
