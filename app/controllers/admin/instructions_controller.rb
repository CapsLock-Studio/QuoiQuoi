class Admin::InstructionsController < AdminController
  authorize_resource
  before_action :set_instruction, only: [:edit]

  def index
    @instruction = Instruction.where(locale_id: params[:locale_id]).first
  end

  def new
    add_breadcrumb '新增訂購說明'

    @instruction = Instruction.new(locale_id: params[:locale_id])
    @instruction.save
  end

  def edit
  end

  def create
    @instruction = Instruction.new(article_params)

    respond_to do |format|
      if @instruction.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: admin_locale_instruction_path(@instruction.locale, @instruction), status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/articles/1
  # PATCH/PUT /admin/articles/1.json
  def update
    respond_to do |format|
      @instruction = Instruction.find(params[:id])
      if @instruction.update_attributes(instruction_params)
        format.html { redirect_to admin_locale_instructions_path(@instruction.locale), notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  private
    def instruction_params
      params.require(:instruction).permit(:id, :content)
    end

    def set_instruction
      @instruction = Instruction.where(locale_id: params[:locale_id]).first
    end
end
