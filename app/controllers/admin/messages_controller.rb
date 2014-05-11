class Admin::MessagesController < AdminController
  authorize_resource

  before_action :set_message, except: [:index, :create, :new]

  def index
    respond_to do |format|
      if params[:user_id]
        add_breadcrumb '首頁', :root_path
        add_breadcrumb '所有使用者訊息', :admin_messages_path
        @user = User.find(params[:user_id])
        add_breadcrumb "用戶id: #{@user.id}"
      else
        @users = User.all.where.not(name: 'guest').reject{|user| user.messages.length <= 0}
      end

      format.html {}
    end
  end

  def show
    add_breadcrumb '首頁', :root_path
    add_breadcrumb '所有使用者訊息', :admin_messages_path
    add_breadcrumb "用戶id: #{@message.user.id}"

    @message.update_attribute(:read, true)
    @new_message = Message.new(user_id: @message.user_id)
  end

  def edit

  end

  def new
    @new_message = Message.new(user_id: params[:user_id] || nil)
  end

  def create
    respond_to do |format|
      @message = Message.new(message_params)
      if @message.update_attributes(message_params.merge({admin: true}))
        format.html {redirect_to admin_user_messages_path(@message.user_id)}
      else
        format.html {render json: @message.errors}
      end
    end
  end

  def update

  end

  def destroy

  end

  private
    def message_params
      params.require(:message).permit(:id, :user_id, :content)
    end
    def set_message
      @message = Message.find(params[:id])
    end
end