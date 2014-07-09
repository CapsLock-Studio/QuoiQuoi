class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @faqs = Faq.all
  end

  def show

  end

  def new
    @faq = Faq.new
  end

  def edit

  end

  def create
    @faq = Faq.new(question_params)
    if @faq.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    if @faq.update_attributes(question_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    if @faq.destroy
      redirect_to action: :index
    else
      render json: @faq.errors
    end
  end

  private
  def set_question
    @faq = Faq.find(params[:id])
  end

  def question_params
    params.require(:faq).permit(:id, :locale_id, :question, :answer)
  end
end