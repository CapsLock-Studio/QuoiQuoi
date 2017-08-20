class Admin::AboutUsController < AdminController
  authorize_resource :admin

  def show

  end

  def edit

  end

  def update
    about_params.each do |_, params|
      $redis.set("about:locale:#{params[:locale_id]}:email", params[:email])
      $redis.set("about:locale:#{params[:locale_id]}:phone", params[:phone])
      $redis.set("about:locale:#{params[:locale_id]}:address", params[:address])
      $redis.set("about:locale:#{params[:locale_id]}:business_hour", params[:business_hour])
      $redis.set("about:locale:#{params[:locale_id]}:introduction", params[:introduction])
    end

    redirect_to action: :show
  end

  private
    def about_params
      params.require(:about)
    end
end