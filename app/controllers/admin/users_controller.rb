class Admin::UsersController < AdminController
  authorize_resource :admin
end
