class CartController < ApplicationController
  # GET /cart
  def index
    add_breadcrumb t('home')
    add_breadcrumb t('cart')

    @order = order_in_cart
    @subtotal = 0
  end
end
