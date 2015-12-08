class Admin::MessagesController < AdminController
  authorize_resource

  def create
    message = Message.new(sanitized_params)
    if message.save
      MessageMailer.remind_to_user(message.id).deliver_later

      redirect_to :back
    else
      render json: 'There are something wrong.'
    end
  end

  private
  def sanitized_params
    params.require(:message).permit(:content, :admin, :custom_order_id)
  end
end