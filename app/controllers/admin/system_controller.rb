class Admin::SystemController < AdminController
  def show

  end

  def edit

  end

  def update
    $redis.set('seo:title', seo_params[:title])
    $redis.set('seo:description', seo_params[:description])

    redirect_to action: :show
  end

  private
  def seo_params
    params.require(:seo).permit(:title, :description)
  end
end
