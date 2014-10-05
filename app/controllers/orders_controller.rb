class OrdersController < ApplicationController
  before_action :set_order, except: [:index, :new, :close_index]
  before_action :authenticate_user!
  before_action :set_discount, only: [:show, :close_show]
  before_action :set_shipping_fee, only: [:show, :close_show]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.in_trading'), :orders_path

    @orders = Order.where(closed: false, checkout: true, user_id: current_user.id, canceled: false).order(:id)
  end

  def new
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('cart'), :cart_path
    add_breadcrumb I18n.t('check_out')

    @subtotal = 0
    @order = order_in_cart
  end

  # GET /orders/1
  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.in_trading'), :orders_path
    add_breadcrumb t('detail')
  end

  # PUT/PATCH /orders/1
  def update
    # summary subtotal
    subtotal = 0

    @order.order_products.each do |order_product|
      subtotal += order_product.price * order_product.quantity
    end
    @order.order_custom_items.each do |order_custom_item|
      subtotal += OrderCustomItemTranslate.where(locale_id: session[:locale_id], order_custom_item_id: order_custom_item.id).first.price
    end

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: params[:order][:shipping_fee_id], locale_id: session[:locale_id]).first
    subtotal += shipping_fee.fee
    if !shipping_fee.free_condition.blank? && subtotal > shipping_fee.free_condition
      subtotal -= shipping_fee.fee
    end

    respond_to do |format|
      @order.order_products.each do |order_product|
        product = Product.find(order_product.product)
        if product.quantity - order_product.quantity < 0
          format.html {render json: 'Products are sold out.'}
        else
          product.update_attribute(:quantity, product.quantity - order_product.quantity)
        end
      end

      locale = Locale.find(session[:locale_id])
      if @order.update_attributes(order_params.merge({checkout: true, subtotal: subtotal, checkout_time: Time.now, locale_id: locale.id, currency: locale.currency}))
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
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.closed')
    @orders = Order.where(closed: true, user_id: current_user.id)

    respond_to do |format|
      format.html {render action: :index}
    end
  end

  # GET /orders/1/close
  def close_show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.closed'), :close_orders_path
    add_breadcrumb t('detail')



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
    if @order.payment

      # if payment completed redirect to registrations page, not allow user to choose pay way again
      # then, if the payment is not completed, we need to delete uncompleted payment and let user to choose pay way again
      if @order.payment.completed?
        redirect_to order_path(@order)
      else
        @order.payment.destroy
        @payment = @order.build_payment
      end
    else

      # has not choose pay way yet
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

    def set_discount
      @discount = 0
      UserGiftSerial.where(order_id: @order.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @order.locale_id).first.quota
      end
    end

    def set_shipping_fee
      @shipping_fee = ShippingFeeTranslate.where(locale_id: @order.locale_id, shipping_fee_id: @order.shipping_fee_id).first
      if @shipping_fee.free_condition && @shipping_fee.free_condition <= @order.subtotal
        @shipping_fee.fee = 0
      end
    end
end
