class Admin::ProductAdditionImagesController < AdminController
  authorize_resource :admin

  before_action :set_product_addition_image, only: [:destroy]

  def index
    @product_addition_images = ProductAdditionImage.where(product_id: params[:product_id])

    render json:
               (@product_addition_images.collect do |product_addition_image|
                 {
                     name: product_addition_image.image.name,
                     size: product_addition_image.image.size,
                     url: "#{request.protocol}#{request.host_with_port}#{product_addition_image.image.url}",
                     thumbnail_url: product_addition_image.image.url(:thumb),
                     delete_url: admin_product_addition_image_path(product_addition_image),
                     delete_type: 'DELETE'
                 }
               end)
  end

  def create
    @product_addition_image = ProductAdditionImage.new(product_addition_image_params)
    respond_to do |format|
      if @product_addition_image.save
        format.html {}
        format.json { render json: {files: [{
                                                name: @product_addition_image.image.name,
                                                size: @product_addition_image.image.size,
                                                url: "#{request.protocol}#{request.host_with_port}#{@product_addition_image.image.url}",
                                                thumbnail_url: @product_addition_image.image.url(:thumb),
                                                delete_url: admin_product_addition_image_path(@product_addition_image),
                                                delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_product_addition_image_path(@product_addition_image) }
      else
        format.html {}
        format.json { render json: @product_addition_image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_addition_image.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  def product_addition_image_params
    params.require(:product_addition_image).permit(:id, :image, :_destroy).merge({product_id: params[:product_id]})
  end

  def set_product_addition_image
    @product_addition_image = ProductAdditionImage.find(params[:id])
  end
end
