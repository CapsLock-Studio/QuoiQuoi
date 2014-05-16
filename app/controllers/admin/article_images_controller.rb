class Admin::ArticleImagesController < AdminController
  authorize_resource

  before_action :set_article_image, only: [:destroy]

  def index
    @article_images = ArticleImage.where(article_id: params[:article_id])

    render json:
      @article_images.collect { |article_image|
        {
            name: article_image.image.name,
            size: article_image.image.size,
            url: "#{request.protocol}#{request.host_with_port}#{article_image.image.url}",
            thumbnail_url: article_image.image.url(:thumb),
            delete_url: admin_article_image_path(article_image),
            delete_type: 'DELETE'
        }
      }
  end

  def create
    @article_image = ArticleImage.new(article_image_params.merge({article_id: params[:article_id]}))
    respond_to do |format|
      if @article_image.save
        format.html {}
        format.json { render json: {files: [{
            name: @article_image.image.name,
            size: @article_image.image.size,
            url: "#{request.protocol}#{request.host_with_port}#{@article_image.image.url}",
            thumbnail_url: @article_image.image.url(:thumb),
            delete_url: admin_article_image_path(@article_image),
            delete_type: 'DELETE'
                                            }]}, status: :created, location: admin_article_image_path(@article_image) }
      else
        format.html {}
        format.json { render json: @article_image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article_image.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  private
    def article_image_params
      params.require(:article_image).permit(:id, :image, :_destroy)
    end

    def set_article_image
      @article_image = ArticleImage.find(params[:id])
    end
end
