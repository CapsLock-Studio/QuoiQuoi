class Admin::ProductOptionsController < AdminController
  def new
    render json: {
        :product_option_group_id => params[:product_option_group_id]
    }
  end

  def show
    render layout: false, locals: {product_option: ProductOption.find(params[:id])}
  end

  def edit
    @product_option = ProductOption.find(params[:id])

    render layout: false
  end

  def create
    product_option = ProductOption.new(product_option_params)
    if product_option.save
      render :show, layout: false, locals: {product_option: product_option}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def update
    product_option = ProductOption.find(params[:id])
    if product_option.update(product_option_params)
      render :show, layout: false, locals: {product_option: product_option}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    if ProductOption.destroy(params[:id])
      render nothing: true
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
  def product_option_params
    params.require(:product_option).permit(:id, :product_option_group_id, :content, :price)
  end
end
