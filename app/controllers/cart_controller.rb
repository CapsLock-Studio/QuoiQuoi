class CartController < ApplicationController
  # GET /cart
  def index
    @order = order_in_cart
    @subtotal = []
  end
end
