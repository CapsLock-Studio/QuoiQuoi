class Admin::OrderCustomItemsController < AdminController
  before_action :set_order_custom_item, except: [:index, :accepted, :check]
  add_breadcrumb '首頁', :admin_root_path

  def index
    @order_custom_items = OrderCustomItem.where(canceled: false).where.not(user_id: ['', nil])
  end

  def show
  end

  def edit
    add_breadcrumb '訂製要求記錄', :admin_order_custom_items_path
    add_breadcrumb '訂製要求詳細'

    if @order_custom_item.order_custom_item_translates.length <= 0
      Locale.order(id: :desc).each do |locale|
        @order_custom_item.order_custom_item_translates.build(locale_id: locale.id)
      end
    end
  end

  def update
    respond_to do |format|

      if @order_custom_item.update_attributes(order_custom_item_params.merge({accept: true, accept_time: Time.now}))
        CustomItem.accept(@order_custom_item.id, params[:lang]).deliver
        format.html {redirect_to action: :index}
      else
        format.html {render json: @order_custom_item.errors}
      end
    end
  end

  # DELETE /admin/order_custom_item/1
  # not accept request
  def destroy
    respond_to do |format|
      if @order_custom_item.update_attributes({accept: false, accept_time: Time.now})
        CustomItem.decline(@order_custom_item.id, params[:lang]).deliver
        format.html {redirect_to action: :index}
      else
        format.html {render json: @order_custom_item.errors}
      end
    end
  end

  def delete
    if @order_custom_item.destroy
      redirect_to action: :check
    else
      render json: @order_custom_item.errors
    end
  end

  def accepted
    @order_custom_items = OrderCustomItem.where(canceled: false, accept: true)
  end

  def check
    @order_custom_items = OrderCustomItem.where(canceled: false, accept: nil, accept_time: nil).where.not(user_id: nil)
  end

  private
    def set_order_custom_item
      @order_custom_item = OrderCustomItem.find(params[:id])
    end

    def order_custom_item_params
      params.require(:order_custom_item).permit(:response, :workday, :estimate_complete_time, :price, :image,
                                                order_custom_item_translates_attributes: [:id, :order_custom_item_id, :locale_id, :price])
    end
end
