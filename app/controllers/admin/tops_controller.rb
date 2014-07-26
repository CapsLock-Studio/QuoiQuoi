class Admin::TopsController < AdminController
  before_action :set_top, except: [:index, :new, :create, :sort]

  # GET /admin/tops
  def index
    @tops = Top.all
  end

  # GET /admin/tops/new
  def new
    @top = Top.new

    Locale.order(id: :desc).each do |locale|
      @top.top_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/tops/1/edit
  def edit

  end

  # POST /admin/tops
  def create
    params = top_params.merge(sort: 1)

    tops = Top.order(:sort)

    unless tops.last.nil?
      params[:sort] = (tops.last.sort.to_i + 1)
    end

    @top = Top.new(params)

    respond_to do |format|
      #format.html {render json: top_params}
      if @top.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :index}
      end
    end
  end

  # PUT/PATCH /admin/tops/1
  def update
    respond_to do |format|
      if @top.update(top_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/tops/1
  def destroy
    respond_to do |format|
      if @top.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/tops/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      slides = Top.update(update_params[:tops].keys, update_params[:tops].values).reject{|p| p.errors.empty?}
      if slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
  def top_params
    params.require(:top).permit(:id, :sort, :image, top_translates_attributes: [:id, :locale_id, :link])
  end

  def set_top
    @top = Top.find(params[:id])
  end

  def update_params
    params.permit(tops: [:id, :sort])
  end
end
