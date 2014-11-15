class Admin::PastWorkTypesController < AdminController
  authorize_resource :admin

  before_action :set_past_work_type, only: [:edit, :update, :destroy, :visible]

  def index
    @past_work_types = PastWorkType.all.order(:sort)
  end

  def new
    @past_work_type = PastWorkType.new
    Locale.all.order(:id).each do |locale|
      @past_work_type.past_work_type_translates.build(locale_id: locale.id)
    end
  end

  def edit
    render 'new'
  end

  def create
    params = past_work_type_params.merge(sort: 1)

    unless PastWorkType.last.nil?
      params[:sort] = (PastWorkType.last.sort.to_i + 1)
    end

    past_work_type = PastWorkType.new(params)
    if past_work_type.save
      redirect_to action: :index
    else
      render json: past_work_type.errors
    end
  end

  def update
    if @past_work_type.update_attributes(past_work_type_params)
      redirect_to action: :index
    else
      render json: @past_work_type.errors
    end
  end

  def destroy
    if @past_work_type.destroy
      redirect_to :back
    else
      render json: @past_work_type.errors
    end
  end

  def visible
    if @past_work_type.update_attribute(:visible, params[:visible])
      redirect_to :back
    else
      render json: @past_work_type.errors
    end
  end

  def sort
    if PastWorkType.update(sort_update_params[:past_work_types].keys, sort_update_params[:past_work_types].values)
      redirect_to :back, flash: {sorted: true}
    else
      render json: @past_work_type.errors
    end
  end

  private
  def set_past_work_type
    @past_work_type = PastWorkType.find(params[:id])
  end

  def past_work_type_params
    params.require(:past_work_type).permit(:id, :thumbnail, :image,
                                           past_work_type_translates_attributes: [:id, :locale_id, :name, :description])
  end

  def sort_update_params
    params.permit(past_work_types: [:id, :sort])
  end
end