class CartController < ApplicationController
  # GET /cart
  def index
    add_breadcrumb t('header.navigation.home')
    add_breadcrumb t('header.navigation.cart')

    @order = order_in_cart
    @subtotal = 0
  end
end
