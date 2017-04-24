class Admin::ProductOptionGroupsController < AdminController
  def index
    @product_option_groups = ProductOptionGroup.includes(:product_options).where(
        locale_id: params[:locale_id] || Locale.first.id,
        product_id: params[:product_id]
    )
    # For sorting option groups and options
    # @product_option_group = @product_option_groups.order('product_option_groups.id, product_options.id')

    render layout: false
  end

  def show
  end

  def new
    @product_option_group = ProductOptionGroup.new(product_id: params[:product_id], locale_id: params[:locale_id])
    @time_in_milliseconds = Time.now.to_i

    render layout: false
  end

  def create
    product_option_group = ProductOptionGroup.new(product_option_group_params)
    if product_option_group.save
      render :show, layout: false, locals: {product_option_group: product_option_group}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def update
    product_option_group = ProductOptionGroup.find(params[:id])

    if product_option_group.update(product_option_group_params)
      render :show, layout: false, locals: {product_option_group: product_option_group}
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    status
    if ProductOptionGroup.destroy(params[:id])
      status = :ok
    else
      status = :unprocessable_entity
    end

    render nothing: true, status: status
  end

  private
  def product_option_group_params
    params.require(:product_option_group).permit(:name, :product_id, :locale_id)
  end
end
