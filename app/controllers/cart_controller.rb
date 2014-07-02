class CartController < ApplicationController
  # GET /cart
  def index
    add_breadcrumb t('home')
    add_breadcrumb t('cart')

    @order = order_in_cart
    @subtotal = 0
  end

  def update
    if order_in_cart.update_attributes(order_params)
      redirect_to new_order_path
    else
      render head: :forbidden
    end
  end

  private
    def order_params
      params.fetch(:order, {}).permit(:id, order_products_attributes: [:id, :quantity])
    end
end
