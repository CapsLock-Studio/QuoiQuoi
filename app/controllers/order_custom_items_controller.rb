class OrderCustomItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    order_custom_item = OrderCustomItem.new
    order_custom_item.custom_order_id = params[:custom_order_id]
    order_custom_item.locale_id = session[:locale_id]
    order_custom_item.order_id = @order_in_cart.id

    if order_custom_item.save
      # render json: order_custom_item
      redirect_to cart_path
    else
      render json: order_custom_item.errors
    end
  end

  def destroy
    order_custom_item = OrderCustomItem.find_by_id_and_order_id(params[:id], @order_in_cart.id)
    order_custom_item.destroy!

    redirect_to cart_path
  end
end
