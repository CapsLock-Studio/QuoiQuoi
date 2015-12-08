class MessagesController < ApplicationController
  before_action :set_message, only: []
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
  end

  def create
    message = Message.new(sanitized_params)
    if message.save
      MessageMailer.remind_to_admin(message.id).deliver_later

      redirect_to :back
    else
      render json: 'There is something wrong.'
    end
  end

  private
  def sanitized_params
    params.require(:message).permit(:content, :custom_order_id)
  end
end
