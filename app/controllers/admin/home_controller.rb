class Admin::HomeController < AdminController
  authorize_resource :admin

  # GET /admin
  def index
  end
end
