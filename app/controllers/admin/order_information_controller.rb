class Admin::OrderInformationController < AdminController
  authorize_resource
  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '訂購須知', :admin_order_information_index_path

  before_action :set_current_order_information, except: [:create, :update, :destroy]
  before_action :set_order_information, only: [:edit, :update, :destroy]

  def index

  end

  def new
    add_breadcrumb '新增', :new_admin_order_information_path
    @order_information = OrderInformation.new(locale_id: params[:locale_id])
  end

  def edit
    add_breadcrumb '修改', :new_admin_order_information_path
  end

  def create
    @order_information = OrderInformation.new(order_information_params)
    respond_to do |format|
      if @order_information.save
        format.html {redirect_to admin_locale_order_information_index_path(@order_information.locale_id)}
      else
        format.html {render json: @order_information.errors}
      end
    end
  end

  def update
    respond_to do |format|
      if @order_information.update_attributes(order_information_params)
        format.html {redirect_to admin_locale_order_information_index_path(@order_information.locale_id)}
      else
        format.html {render json: @order_information.errors}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @order_information.destroy
        format.html {redirect_to admin_locale_order_information_index_path(@order_information.locale_id)}
      else
        format.html {render json: @order_information.errors}
      end
    end
  end

  private
  def set_current_order_information
    @current_order_information = OrderInformation.where(locale_id: params[:locale_id])
  end

  def set_order_information
    @order_information = OrderInformation.find(params[:id])
  end

  def order_information_params
    params.require(:order_information).permit(:id, :locale_id, :bag_type, :reference, :note)
  end
end
