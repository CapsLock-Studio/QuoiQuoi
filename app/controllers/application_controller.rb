class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :set_locale
  before_action :set_product_types
  before_action :set_product_tags
  before_action :set_article_types
  before_action :set_order_in_cart
  before_action :configure_devise_params, if: :devise_controller?
  before_action :set_default_seo_properties
  before_action :test_hook

  def test_hook
    #session.delete(:guest_user_id)
  end

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
    if is_locale_changed?
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale_id] = Locale.select(:id).where(lang: (session[:locale] || I18n.default_locale)).first.id
  end

  def set_product_types
    @product_types = ProductType.includes(:product_type_translate)
                                .where(product_type_translates: {locale_id: session[:locale_id]})
  end

  def set_product_tags
    @product_tags = ProductTag.includes(:product_tag_translate)
                                .where(product_tag_translates: {locale_id: session[:locale_id]})
                                .order(:sort)
  end

  def set_article_types
    @article_types = ArticleType.where(locale_id: session[:locale_id]).includes(:articles)
  end

  def after_sign_in_path_for(resource)
    # Order items in cart change it's owner.
    if session[:guest_user_id] && @order_in_cart
      @order_in_cart.user_id = resource.id
      @order_in_cart.save

      User.find(session[:guest_user_id]).destroy
      session.delete(:guest_user_id)
    end

    super
  end

  def configure_devise_params

    # custom the user sign up parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  private
  def set_order_in_cart
    if session[:guest_user_id]
      @order_in_cart = Order.in_cart(session[:guest_user_id])
    elsif user_signed_in?
      @order_in_cart = Order.in_cart(current_user.id)
    end

    if is_locale_changed? && @order_in_cart && @order_in_cart.in_cart_empty?
      @order_in_cart.locale_id = session[:locale_id]
      @order_in_cart.currency = Locale.select(:id, :currency).find(session[:locale_id]).currency
      @order_in_cart.save
    end
  end

  def set_default_seo_properties
    @website_title = $redis.get("seo:locale:#{session[:locale_id]}:title")
    @meta_og_description = $redis.get("seo:locale:#{session[:locale_id]}:description")
    @meta_og_image = ActionController::Base.helpers.asset_url('logo-og.png')
    @meta_og_title = $redis.get("seo:locale:#{session[:locale_id]}:og:title")
    @meta_og_type = 'website'
  end

  def is_locale_changed?
    (!params[:locale].nil? && I18n.available_locales.include?(params[:locale].to_sym))
  end
end
