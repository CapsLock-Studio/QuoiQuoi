class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :set_locale
  before_action :set_product_types

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      if is_a?(Devise::SessionsController) || is_a?(Devise::RegistrationsController) || is_a?(Devise::PasswordsController)
        'admin_login'
      end
    else
      'application'
    end
  end

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale_id] = Locale.select(:id).where(lang: (session[:locale] || I18n.default_locale))
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
end
