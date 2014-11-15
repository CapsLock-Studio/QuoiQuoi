class CartController < ApplicationController
  # GET /cart
  def index
    add_breadcrumb t('home')
    add_breadcrumb t('cart')

    @subtotal = 0
  end

  def update
    if @order_in_cart.update_attributes(order_params)
      @order_in_cart.order_products.each do |order_product|
        if order_product.product_option
          order_product.price = order_product.product.product_translates.where(locale_id: session[:locale_id]).first.price + order_product.product_option.price
          order_product.save
        end
      end
      redirect_to new_order_path
    else
      render head: :forbidden
    end
  end

  private
    def order_params
      params.fetch(:order, {}).permit(:id, order_products_attributes: [:id, :quantity, :product_option_id])
    end
end
