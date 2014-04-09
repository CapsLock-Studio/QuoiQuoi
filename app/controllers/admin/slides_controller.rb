class Admin::SlidesController < AdminController
  before_action :set_slide, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '輪播列表', :admin_slides_path

  # GET /admin/slides
  def index
    @slides = Slide.order(:sort)
  end

  # GET /admin/slides/new
  def new
    add_breadcrumb '新增輪播'

    @slide = Slide.new
    locales = Locale.all
    locales.each do |locale|
      @slide.slide_translates.build(locale_id: locale.id)
    end

    @slide_positions = SlidePosition.all
  end

  # GET /admin/slides/edit
  def edit
    add_breadcrumb '修改輪播'

    @slide_positions = SlidePosition.all
  end

  # POST /admin/slides
  def create
    params = slide_params.merge(sort: 1)

    slides = Slide.order(:sort)

    unless slides.last.nil?
      params[:sort] = (slides.last.sort.to_i + 1)
    end

    @slide = Slide.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @slide.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/slides/1
  def update
    respond_to do |format|
      if @slide.update(slide_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/slides/1
  def destroy
    respond_to do |format|
      if @slide.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/slides/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      slides = Slide.update(update_params[:slides].keys, update_params[:slides].values).reject{|p| p.errors.empty?}
      if slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def slide_params
      params.require(:slide).permit(:id, :link, :image, :sort, :slide_position_id,
                                    slide_translates_attributes: [:id, :locale_id, :title, :description])
    end

    def set_slide
      @slide = Slide.find(params[:id])
    end

    def update_params
      params.permit(slides: [:id, :sort])
    end
end
