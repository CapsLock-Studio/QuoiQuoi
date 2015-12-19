class CustomOrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_custom_order, only: [:show, :cancel]

  def index
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('custom_order.my')

    @custom_orders = CustomOrder.where(user_id: current_user.id).order(:created_at)
  end

  def new
    @material_likes = Material.includes(:material_translate).where(material_translates: {locale_id: session[:locale_id]},
                                                                   id: JSON.parse(cookies['material-likes'] || '[]'))
  end

  def show
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('custom_order.my'), custom_orders_path
    add_breadcrumb t('detail')

    @messages = Message.where(custom_order_id: params[:id]).order(:created_at)
    @messages.where(admin: true).update_all({read: true})
  end

  def build
    @custom_order = CustomOrder.new
    @custom_order.order_type = sanitize_params[:order_type] || '現貨修改'
    @custom_order.style = sanitize_params[:style] || '現貨修改'
    @custom_order.materials = sanitize_params[:materials]
    @custom_order.email = sanitize_params[:email]
    @custom_order.phone = sanitize_params[:phone]
    @custom_order.line = sanitize_params[:line]
    @custom_order.description = sanitize_params[:description]
    @custom_order.size = sanitize_params[:size]
    @custom_order.references = sanitize_params[:references]
    @custom_order.user_id = current_user.id
    @custom_order.locale_id = session[:locale_id]
    @custom_order.product_id = sanitize_params[:product_id]

    if @custom_order.save
      # add_breadcrumb t('home'), root_path
      # add_breadcrumb t('custom_order.my'), custom_orders_path
      # add_breadcrumb t('detail')

      CustomMailer.remind_new_order(@custom_order.id).deliver_later

      redirect_to @custom_order
    else
      render json: 'Sorry, there is something wrong building order.'
    end
  end

  def create
    redirect_result = { redirectNow: false, redirectUrl: '' }
    if current_user.nil?
      user = User.find_by_email(sanitize_params[:email])
      if user.nil?
        user = User.new(email: sanitize_params[:email])
        user.name = sanitize_params[:name]
        user.phone = sanitize_params[:phone]
        user.line = sanitize_params[:line]
        user.password = Devise.friendly_token[0, 20]
        user.save!
      end
      # Using email to sign in.
      UserMailer.signin_confirmation(user, build_custom_orders_path(sanitize_params)).deliver_later
    else
      current_user.name = sanitize_params[:name]
      current_user.phone = sanitize_params[:phone]
      current_user.line = sanitize_params[:line]
      current_user.save!

      redirect_result[:redirectNow] = true
      redirect_result[:redirectUrl] = build_custom_orders_path(sanitize_params)
    end

    render json: redirect_result
  end

  def cancel
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('custom_order.my'), custom_orders_path
    add_breadcrumb t('detail')

    if @custom_order.approve.nil? && !@custom_order.cancel?
      flash.now[:icon] = 'fa-user-times'
      flash.now[:message] = t('order_cancel')
      flash.now[:status] = 'success'

      @custom_order.cancel = true
      @custom_order.cancel_reason = params[:cancel_reason]
      @custom_order.cancel_time = Time.now
      @custom_order.save!
    else
      flash.now[:icon] = 'fa-lightbulb-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_already_completed')
    end

    render action: :show
  end

  private
  def sanitize_params
    params.permit(:order_type, :style, :materials, :name, :email, :phone, :size, :references, :description, :line, :product_id)
  end

  def set_custom_order
    @custom_order = CustomOrder.find_by_id_and_user_id(params[:id], current_user.id)
  end
end
