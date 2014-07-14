class OrderProductsController < ApplicationController
  include ApplicationHelper

  # POST /order_products
  def create

    order_product = order_in_cart.order_products.build(order_product_params)
    order_product.discount = order_product.product.discount
    order_product.price = price_discount(order_product.product.product_translates.where(locale_id: session[:locale_id]).first.price, order_product.product.discount)

    respond_to do |format|
      if order_product.product.quantity - order_product.quantity < 0
        format.html {render json: 'Products are sold out'}
      elsif order_product.save
        format.html {redirect_to cart_path}
      else
        format.html {render json: order_product.errors}
      end
    end
  end

  def destroy
    order_product = order_in_cart.order_products.find(params[:id])
    respond_to do |format|
      if order_product.destroy
        format.html {redirect_to cart_path}
      else
        format.html {render json: order_product}
      end
    end
  end

  private
    def order_product_params
      #params.require(:order_product).permit!
      params.require(:order_product).permit(:product_id, :quantity)
    end
end