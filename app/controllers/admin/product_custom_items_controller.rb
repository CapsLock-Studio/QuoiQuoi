class Admin::ProductCustomItemsController < AdminController
  before_action :set_product
  before_action :set_product_custom_item, only: [:edit, :update, :destroy]

  def index
    @product_custom_items = @product.product_custom_items.order(id: :desc).page(params[:page]).per(16)
  end

  def new
    @product_custom_item = @product.product_custom_items.build
    Locale.all.each do |locale|
      @product_custom_item.product_custom_item_translates.build(locale_id: locale.id)
    end
  end

  def edit

  end

  def create
    respond_to do |format|
      @product_custom_item = @product.product_custom_items.build(product_custom_item_params)
      if @product_custom_item.save
        format.html {redirect_to action: :index}
      else
        format.html {render action: :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @product_custom_item.update_attributes(product_custom_item_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy

  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_product_custom_item
      @product_custom_item = ProductCustomItem.find(params[:id])
    end

    def product_custom_item_params
      params.require(:product_custom_item).permit(:id, :image, product_custom_item_translates_attributes: [:id, :locale_id, :name])
    end
end
