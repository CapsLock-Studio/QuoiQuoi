class OrderCustomItemsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :material]
  before_action :set_order_custom_item, except: [:index, :new, :create, :material]


  # GET /order_custom_items
  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('custom_order.my'), :order_custom_items_path

    @order_custom_items = OrderCustomItem.where(canceled: false, user_id: current_user.id, order_id: ['', nil])
  end

  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('custom_order.my'), :order_custom_items_path
    add_breadcrumb t('detail')

    if @order_custom_item.user_id != current_user.id
      flash.now[:status] = 'warning'
      flash.now[:message] = t('wrong_user_warning')
    end
  end

  # GET /order_custom_items/material
  def material
    respond_to do |format|
      @materials = Material.all.page(params[:page]).per(16)
      format.html {render 'material', layout: false}
    end
  end

  # GET /order_custom_items/new
  def new
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('personalize')

    @website_title = "#{t('personalize')} | #{@website_title}"

    respond_to do |format|
      # @materials = Material.all.page(params[:page]).per(16)
      # show materials by category
      @material_types = MaterialType.all.order(:id)

      if params[:product_id]
        @product_custom_items = ProductCustomItem.where(product_id: params[:product_id]).page(params[:page]).per(99)
      else
        @order_information = OrderInformation.where(locale_id: session[:locale_id])
      end

      format.html do
        @order_custom_item = OrderCustomItem.new(product_id: params[:product_id] || nil)
        @order_custom_item.order_custom_item_images.build
      end

      format.json {}
    end
  end

  # GET /order_custom_items/1/edit
  def edit
  end

  # POST /order_custom_items
  def create
    @order_custom_item = OrderCustomItem.create(order_custom_item_params.merge({locale_id: session[:locale_id]}))

    if current_user.nil?
      session[:temp] = @order_custom_item.id
      flash[:alert] = t('devise.failure.unauthenticated')
      flash[:email] = params[:email]
      redirect_to new_user_session_path
    else
      #format.html {render json: order_custom_item_params}
      @order_custom_item.user_id = current_user.id
      if @order_custom_item.save
        redirect_to order_custom_item_path(@order_custom_item)
      else
        render json: @order_custom_item.errors
      end
    end
  end

  # PUT/PATCH /order_custom_items/1
  def update
    respond_to do |format|
      if @order_custom_item.accept? && (@order_custom_item.order_custom_item_translates.length > 0)
        if @order_custom_item.update_attribute(:order_id, order_in_cart.id)
          format.html {redirect_to cart_path}
        else
          format.html {render json: @order_custom_item.errors}
        end
      else
        format.html {render json: 'you can not modify this order_custom_item'}
      end
    end
  end

  # DELETE /order_custom_items/1
  def destroy
    respond_to do |format|
      if @order_custom_item.update_attribute(:order_id, '')
        format.html {redirect_to cart_path}
      else
        format.html {render json: @order_custom_item.errors}
      end
    end
  end

  def cancel
    respond_to do |format|
      if @order_custom_item.update_attributes({canceled: true, canceled_time: Time.now})
        format.html {redirect_to action: :index}
      else
        format.html {render json: @order_custom_item.errors}
      end
    end
  end

  private
    def order_custom_item_params
      params.require(:order_custom_item).permit(:id, :name, :product_id, :order_id, :design, :style, :material_id,
                                                :description, :line, :phone, :image,
                                                order_custom_item_images_attributes: [:id, :order_custom_item_id, :image],
                                                order_custom_item_materials_attributes: [:id, :order_custom_item_id, :material_id],
                                                order_custom_item_product_custom_items_attributes: [:id, :order_custom_item_id, :product_custom_item_id])
    end

    def set_order_custom_item
      #@order_custom_item = OrderCustomItem.includes(:order_custom_item_translate)
      #                                    .where(order_custom_item_translates: {locale_id: session[:locale_id]})
      #                                    .find(params[:id])
      @order_custom_item = OrderCustomItem.joins("LEFT OUTER JOIN order_custom_item_translates ON (order_custom_items.id = order_custom_item_translates.order_custom_item_id AND order_custom_item_translates.locale_id = #{session[:locale_id]})")
                                          .find(params[:id])
    end
end
