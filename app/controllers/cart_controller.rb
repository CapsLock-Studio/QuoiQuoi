class CartController < ApplicationController
  before_action :authenticate_user!, only: [:checkout, :payment]

  # GET /cart
  def index
    add_breadcrumb t('home')
    add_breadcrumb t('cart')

    @subtotal = 0
  end

  def update
    if @order_in_cart.update_attributes(order_params)
      @order_in_cart.order_products.each do |order_product|
        total_option_price = 0
        order_product.order_product_options.each do |order_option|
          total_option_price += order_option.product_option.price
        end

        order_product.price = order_product.raw_price(@order_in_cart.locale_id) + total_option_price
        order_product.save
        #if order_product.product_option
        #  order_product.price = order_product.product.product_translates.where(locale_id: session[:locale_id]).first.price + order_product.product_option.price
        #  order_product.save
        #end
      end
      redirect_to cart_checkout_path
    else
      render head: :forbidden
    end
  end

  def checkout
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('cart'), :cart_path
    add_breadcrumb I18n.t('check_out')

    # default values
    @order_in_cart.shipping_fee = ShippingFee.first if @order_in_cart.shipping_fee.nil?
    @order_in_cart.locale_id = session[:locale_id]
  end

  def payment
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('cart'), :cart_path
    add_breadcrumb I18n.t('check_out')

    @order_in_cart.update(checkout_info_params)

    @gift_card_quota = 0
    @gift_card_serial = params[:gift_card_serial]

    if !@gift_card_serial.nil? and @gift_card_serial != ''
      begin
        @gift_card_quota = UserGiftSerial.find_by_serial(@gift_card_serial)
                               .user_gift
                               .gift
                               .gift_translates
                               .find_by_locale_id(session[:locale_id])
                               .quota
      rescue
        flash.now[:icon] = 'fa-frown-o'
        flash.now[:status] = 'warning'
        flash.now[:message] = t('user_gift.not_found')
      end
    end
  end

  private
    def order_params
      params.fetch(:order, {}).permit(:id, order_products_attributes: [:id, :quantity, :product_option_id,
                                                                       order_product_options_attributes: [:id, :product_option_id]])
    end

    def checkout_info_params
      result = params.require(:order).permit(:name, :address, :phone, :zip_code, :shipping_fee_id, :payment_method)
      # result[:shipping_fee_id] = result[:shipping_fee_id].to_i

      result
    end
end
