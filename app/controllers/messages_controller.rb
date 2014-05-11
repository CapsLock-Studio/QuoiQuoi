class MessagesController < ApplicationController
  before_action :set_message, except: [:index, :create, :new]
  before_action :authenticate_user!

  def index
    @messages = Message.where(user_id: current_user.id).order(id: :desc).page(params[:page]).per(12)
  end

  def show

    if @message.admin? && !@message.read?
      unless @message.update_attribute(:read, true)
        render json: @message.errors
      end
    end
  end

  def new

    @message = Message.new
  end

  def create
    respond_to do |format|
      @message = Message.new(message_params.merge(user_id: current_user.id))
      if @message.save
        format.html {redirect_to action: :index}
      else
        format.html {render action: :new}
      end
    end
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
