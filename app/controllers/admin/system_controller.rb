class Admin::SystemController < AdminController
  def show

  end

  def update
    $redis.set("seo:locale:#{params[:locale_id]}:title", params['title'])
    $redis.set("seo:locale:#{params[:locale_id]}:og:title", params['og:title'])
    $redis.set("seo:locale:#{params[:locale_id]}:description", params['description'])

    redirect_to action: :show
  end
end
