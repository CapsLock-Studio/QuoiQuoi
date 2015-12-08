class Admin::PastWorksController < AdminController
  authorize_resource :admin

  before_action :set_past_work, only: [:edit, :update, :visible, :destroy]
  before_action :set_past_work_type, only: [:index, :new]
  before_action :delete_empty_past_work, except: [:create, :update]

  def index
  end

  def new
    @past_work = PastWork.create(past_work_type_id: @past_work_type.id)
    Locale.all.order(:id).each do |locale|
      @past_work.past_work_translates.create(locale_id: locale.id)
    end

    @image_addition = PastWorkAdditionImage.new(past_work_id: @past_work.id)
    @article = @past_work
  end

  def edit
    @past_work_type = @past_work.past_work_type

    @image_addition = PastWorkAdditionImage.new(past_work_id: @past_work.id)
    @article = @past_work

    render 'new'
  end

  def create

  end

  def update
    if @past_work.update_attributes(past_work_params)
      redirect_to admin_past_work_type_past_works_path(@past_work.past_work_type)
    else
      render json: @past_work.errors
    end
  end

  def visible
    if @past_work.update_column(:visible, params[:visible])
      redirect_to :back
    else
      render @past_work.errors
    end
  end

  def destroy
    if @past_work.destroy
      redirect_to :back
    else
      render json: @past_work.errors
    end
  end

  private

  def set_past_work
    @past_work = PastWork.find(params[:id])
  end

  def set_past_work_type
    @past_work_type = PastWorkType.find(params[:past_work_type_id])
  end

  def past_work_params
    params.require(:past_work).permit(:id, :image, :completion_time,
                                      past_work_translates_attributes: [:id, :name, :order_type, :style, :size, :description, :locale_id])
  end

  def delete_empty_past_work
    # destroy empty record
    PastWork.where(completion_time: nil).destroy_all
  end
end
