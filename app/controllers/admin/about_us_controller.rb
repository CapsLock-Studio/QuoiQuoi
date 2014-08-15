class Admin::AboutUsController < AdminController
  authorize_resource :admin

  def show

  end

  def edit

  end

  def update
    about_params.each do |params|
      $redis.set("about:locale:#{params[1][:locale_id]}:email", params[1][:email])
      $redis.set("about:locale:#{params[1][:locale_id]}:phone", params[1][:phone])
      $redis.set("about:locale:#{params[1][:locale_id]}:address", params[1][:address])
      $redis.set("about:locale:#{params[1][:locale_id]}:business_hour", params[1][:business_hour])
      $redis.set("about:locale:#{params[1][:locale_id]}:introduction", params[1][:introduction])
    end

    redirect_to action: :show
  end

  private
    def about_params
      params.require(:about)
    end
end