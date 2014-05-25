class OrdersController < ApplicationController
  before_action :set_order, except: [:index, :new, :close_index]
  before_action :authenticate_user!

  def index
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('order_in_trading'), :orders_path

    @orders = Order.where(closed: false, checkout: true, user_id: current_user.id, canceled: false)
  end

  def new
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb I18n.t('header.navigation.cart'), :cart_path
    add_breadcrumb I18n.t('check_out')

    @subtotal = 0
    @order = order_in_cart
  end

  # GET /orders/1
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('order_in_trading'), :orders_path
    add_breadcrumb '訂單詳細'
  end

  # PUT/PATCH /orders/1
  def update
    # summary subtotal
    subtotal = 0

    @order.order_products.each do |order_product|
      subtotal += order_product.product.price
    end
    @order.order_custom_items do |order_custom_item|
      subtotal += order_custom_item.price
    end

    shipping_fee = ShippingFee.find(params[:order][:shipping_fee_id])
    subtotal += shipping_fee.fee
    if !shipping_fee.free_condition.blank? && subtotal > shipping_fee.free_condition
      subtotal -= shipping_fee.fee
    end

    respond_to do |format|
      if @order.update_attributes(order_params.merge({checkout: true, subtotal: subtotal, checkout_time: Time.now}))
        format.html {redirect_to pay_order_path(@order)}
      else
        format.html {render json: @order.errors}
      end
    end
  end

  def destroy
  end

  def cancel
    respond_to do |format|
      if (!@order.payment || !@order.payment.completed?) && @order.update_attributes({canceled: true, canceled_time: Time.now})
        format.html {redirect_to action: :index}
      else
        format.html {render json: @order.errors}
      end
    end
  end

  # GET /orders/close
  def close_index
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('closed_order')
    @orders = Order.where(closed: true)

    respond_to do |format|
      format.html {render action: :index}
    end
  end

  # GET /orders/1/close
  def close_show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('closed_order'), :close_orders_path
    add_breadcrumb '訂單詳細'

    respond_to do |format|
      format.html {render action: :show}
    end
  end

  # PUT/PATCH /orders/1/close
  def close
    if @order.paid? && @order.delivered?
      respond_to do |format|
        if @order.update_attributes({closed: true, closed_time: Time.now})
          format.html {redirect_to close_order_path(@order)}
        else
          format.html {render json: @order.errors}
        end
      end
    else
      respond_to do |format|
        format.html {render action: :show}
      end
    end
  end

  # GET /orders/1/pay
  def pay_show
    if @order.payment && @order.payment.completed?
      redirect_to order_path(@order)
    elsif @order.payment
      @order.payment.destroy
      @payment = @order.build_payment
    else
      @payment = @order.build_payment
    end
  end

  private
    def set_order
      @order = Order.where(id: params[:id], user_id: current_user.id).first
    end

    def order_params
      params.require(:order).permit(:name, :address, :phone, :zip_code, :shipping_fee_id)
    end
end
