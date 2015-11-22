class Admin::CustomOrderOptionsController < AdminController
  def index
  end

  def create
    array = JSON.parse($redis.get(params[:key]) || '[]')
    array << params[:value]
    $redis.set(params[:key], array.to_json)

    redirect_to action: :index
  end

  def update
    unless $redis.get(params[:key]).nil?
      array = JSON.parse($redis.get(params[:key]))
      array[params[:id].to_i] = params[:value]
      $redis.set(params[:key], array.to_json)
    end

    redirect_to action: :index
  end

  def destroy
    unless $redis.get(params[:key]).nil?
      array = JSON.parse($redis.get(params[:key]))
      array.delete_at(params[:id].to_i)
      $redis.set(params[:key], array.to_json)
    end

    redirect_to action: :index
  end
  
  private
  def sanitize_params
    params.permit(:order_type, :locale_id)
  end
end
