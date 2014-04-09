class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :set_locale
  before_action :set_product_types
  before_action :set_side_menu_orders

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      if is_a?(Devise::SessionsController) || is_a?(Devise::RegistrationsController) || is_a?(Devise::PasswordsController)
        'admin_login'
      end
    else
      'application'
    end
  end

  def set_side_menu_orders
    if session[:guest_user_id] || user_signed_in?
      @menu_orders = order_in_cart
    end
  end

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale_id] = Locale.select(:id).where(lang: (session[:locale] || I18n.default_locale))
  end

  # if user is logged in , return current user, else return guest
  def current_or_guest_user
    if current_user
      # if current user has guest_user_id means just logged in from guest
      # so we need to store the actions when user was guest done to current user
      if session[:guest_user_id]
        store_actions_to_current_user

        # discard guest identity
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user
    begin
      @cache_guest_user = User.find(session[:guest_user_id] || create_guest_user.id)
    rescue ActiveRecord::RecordNotFound

      # retry again
      session[:guest_user_id] = nil
      guest_user
    end
  end

  def order_in_cart
    Order.where(user_id: current_or_guest_user.id, checkout: false).first || create_order(current_or_guest_user.id)
  end

  #def current_ability
  #  @current_ability ||= case
  #                         when current_user
  #                           Ability.new(current_user)
  #                         when current_admin
  #                           AdminAbility.new(current_admin)
  #                       end
  #end

  def set_product_types
    @product_types = ProductType.all
  end

  private
    def store_actions_to_current_user
      user_not_closed_order.update_attributes(user_id: current_user.id)
    end

    def create_guest_user
      user = User.create({name: 'guest', email: "guest_#{Time.now.to_i}_#{rand(99)}@example.com"})
      user.save!(validate: false)
      session[:guest_user_id] = user.id

      user
    end

    def create_order(user_id)
      order = Order.create({closed: false, user_id: user_id, checkout: false})
      order.save!(validate: false)

      order
    end
end
