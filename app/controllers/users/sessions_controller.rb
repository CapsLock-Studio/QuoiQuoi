class Users::SessionsController < Devise::SessionsController
  def create

    # Same as session create, because user will pick up cart un guest then sign in or they was guest then sign up.
    # So we need to handle these two situations.
    super do |resource|
      if session[:guest_user_id] && @order_in_cart
        @order_in_cart.user_id = resource.id
        @order_in_cart.save

        User.find(session[:guest_user_id]).destroy
        session.delete(:guest_user_id)
      end
    end
  end
end