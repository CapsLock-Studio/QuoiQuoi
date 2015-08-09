class Admin::UsersController < AdminController
  authorize_resource :admin

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '用戶列表', :admin_users_path

  def index
    @users = User.where.not(name: 'guest')
  end

  def show
  end

  def info
    @user = User.find(params[:id])

    render layout: false
  end
end