class Admin::IntroduceImageSlidesController < AdminController
  authorize_resource

  before_action :set_introduce_image_slide, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '圖片輪播列表', :admin_introduce_image_slides_path

  # GET /admin/introduce_image_slides
  def index
    @introduce_image_slides = IntroduceImageSlide.order(:sort)
  end

  # GET /admin/introduce_image_slides/new
  def new
    add_breadcrumb '新增輪播'

    @introduce_image_slide = IntroduceImageSlide.new
  end

  # GET /admin/introduce_image_slides/edit
  def edit
    add_breadcrumb '修改輪播'
  end

  # POST /admin/introduce_image_slides
  def create
    params = introduce_image_slide_params.merge(sort: 1)

    introduce_image_slides = IntroduceImageSlide.order(:sort)

    unless introduce_image_slides.last.nil?
      params[:sort] = (introduce_image_slides.last.sort.to_i + 1)
    end

    @introduce_image_slide = IntroduceImageSlide.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @introduce_image_slide.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/introduce_image_slides/1
  def update
    respond_to do |format|
      if @introduce_image_slide.update(introduce_image_slide_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/introduce_image_slides/1
  def destroy
    respond_to do |format|
      if @introduce_image_slide.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/introduce_image_slides/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      introduce_image_slides = IntroduceImageSlide.update(update_params[:introduce_image_slides].keys, update_params[:introduce_image_slides].values).reject{|p| p.errors.empty?}
      if introduce_image_slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def introduce_image_slide_params
      params.require(:introduce_image_slide).permit(:id, :sort, :image)
    end

    def set_introduce_image_slide
      @introduce_image_slide = IntroduceImageSlide.find(params[:id])
    end

    def update_params
      params.permit(introduce_image_slides: [:id, :sort])
    end
end
