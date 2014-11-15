class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      if session[:guest_user_id]
        @order_in_cart.user_id = resource.id
        @order_in_cart.save

        User.find(session[:guest_user_id]).destroy
        session.delete(:guest_user_id)
      end
    end
  end
end