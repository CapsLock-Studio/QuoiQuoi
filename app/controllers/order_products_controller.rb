class OrderProductsController < ApplicationController

  # POST /order_products
  def create

    if @order_in_cart.nil?
      @order_in_cart = Order.create_cart((user_signed_in?)? current_user.id : (session[:guest_user_id] = User.create_guest_user.id), session[:locale_id])
    end

    order_product = @order_in_cart.order_products.build(order_product_params)
    order_product.discount = order_product.product.discount
    price = order_product.product.product_translates.where(locale_id: session[:locale_id]).first.price
    if order_product.product_option
      price += order_product.product_option.price
    end
    order_product.price = ApplicationController.helpers.price_discount(price, order_product.product.discount)

    if order_product.product.quantity - order_product.quantity < 0
      render json: 'Products are sold out'
    elsif order_product.save
      redirect_to cart_path
    else
      render json: order_product.errors
    end
  end

  def destroy
    if @order_in_cart.order_products.find(params[:id]).destroy
      redirect_to cart_path
    else
      render json: order_product
    end
  end

  private
  def order_product_params
    #params.require(:order_product).permit!
    params.require(:order_product).permit(:product_id, :quantity, :product_option_id)
  end
end