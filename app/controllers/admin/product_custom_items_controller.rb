class Admin::ProductCustomItemsController < AdminController
  before_action :set_product, only: [:index, :update]

  def index
  end

  def create
    array = JSON.parse($redis.get(params[:key]) || '[]')
    array << params[:value]
    $redis.set(params[:key], array.to_json)

    redirect_to :back
  end

  def update
    unless $redis.get(params[:key]).nil?
      array = JSON.parse($redis.get(params[:key]))
      array[params[:id].to_i] = params[:value]
      $redis.set(params[:key], array.to_json)
    end

    redirect_to action: :index, product_id: @product.id
  end

  def destroy
    unless $redis.get(params[:key]).nil?
      array = JSON.parse($redis.get(params[:key]))
      array.delete_at(params[:id].to_i)
      $redis.set(params[:key], array.to_json)
    end

    redirect_to :back
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end
end
