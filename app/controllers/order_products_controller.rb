class OrderProductsController < ApplicationController
  # POST /order_products
  def create
    # reformat params
    order_product_params[:order_product_custom_items_attributes] = order_product_custom_items_attributes

    order_product = order_in_cart.order_products.build(order_product_params)

    respond_to do |format|
      if order_product.save
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
    def order_product_custom_items_attributes
      order_product_custom_items_attributes = {}
      counter = 0

      unless order_product_params[:order_product_custom_items_attributes].nil?
        order_product_params[:order_product_custom_items_attributes].each do |order_custom_item|
          if order_custom_item[1][:product_custom_item_id].is_a?(Array)
            order_custom_item[1][:product_custom_item_id].each do |product_custom_item_id|
              unless product_custom_item_id.blank?
                order_product_custom_items_attributes["#{counter}".to_sym] = {
                    product_custom_item_id: product_custom_item_id
                }
                counter = counter + 1
              end
            end
          else
            unless order_custom_item[1][:product_custom_item_id].blank?
              order_product_custom_items_attributes["#{counter}".to_sym] = {
                  product_custom_item_id: order_custom_item[1][:product_custom_item_id]
              }
              counter = counter + 1
            end
          end
        end
      end

      ActionController::Parameters.new(order_product_custom_items_attributes)
    end

    def order_product_params
      params.require(:order_product).permit!
      #params.require(:order_product).permit(:product_id,
      #                                      order_product_custom_items_attributes: [:product_custom_item_id])
    end
end