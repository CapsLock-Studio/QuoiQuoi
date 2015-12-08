class Admin::CustomOrdersController < AdminController
  before_action :set_custom_order, only: [:show, :update]
  def index
    @custom_orders = CustomOrder.where(approve: [nil, true], cancel: false)
  end

  def show
    @custom_order.messages.where(admin: false).update_all({read: true})
  end

  def update
    @custom_order.approve = params[:approve]
    @custom_order.price = params[:price]
    @custom_order.dismiss_message = params[:dismiss_message]
    if @custom_order.save
      flash[:approve] = params[:approve]

      if @custom_order.approve?
        @custom_order.approve_time = Time.now
        @custom_order.save

        CustomMailer.approve(@custom_order.id).deliver_later
      else
        CustomMailer.dismiss(@custom_order.id).deliver_later
      end

      flash[:id] = @custom_order.id
      redirect_to (params[:from_discussing] == 'true')? discussing_admin_custom_orders_path : admin_custom_orders_path
    else
      render json: @custom_order.errors
    end
  end

  def discussing
    @custom_orders = CustomOrder.where(approve: nil, cancel: false)
  end

  def canceled
    @custom_orders = CustomOrder.where('approve = ? OR cancel = ?', false, true)
  end

  private
  def set_custom_order
    @custom_order = CustomOrder.find(params[:id])
  end
end
