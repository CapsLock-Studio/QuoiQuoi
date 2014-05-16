class Admin::ContactImageSlidesController < AdminController
  authorize_resource

  before_action :set_contact_image_slide, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '圖片輪播列表', :admin_contact_image_slides_path

  # GET /admin/contact_image_slides
  def index
    @contact_image_slides = ContactImageSlide.order(:sort)
  end

  # GET /admin/contact_image_slides/new
  def new
    add_breadcrumb '新增輪播'

    @contact_image_slide = ContactImageSlide.new
  end

  # GET /admin/contact_image_slides/edit
  def edit
    add_breadcrumb '修改輪播'
  end

  # POST /admin/contact_image_slides
  def create
    params = contact_image_slide_params.merge(sort: 1)

    contact_image_slides = ContactImageSlide.order(:sort)

    unless contact_image_slides.last.nil?
      params[:sort] = (contact_image_slides.last.sort.to_i + 1)
    end

    @contact_image_slide = ContactImageSlide.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @contact_image_slide.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/contact_image_slides/1
  def update
    respond_to do |format|
      if @contact_image_slide.update(contact_image_slide_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/contact_image_slides/1
  def destroy
    respond_to do |format|
      if @contact_image_slide.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/contact_image_slides/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      contact_image_slides = ContactImageSlide.update(update_params[:contact_image_slides].keys, update_params[:contact_image_slides].values).reject{|p| p.errors.empty?}
      if contact_image_slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def contact_image_slide_params
      params.require(:contact_image_slide).permit(:id, :sort, :image)
    end

    def set_contact_image_slide
      @contact_image_slide = ContactImageSlide.find(params[:id])
    end

    def update_params
      params.permit(contact_image_slides: [:id, :sort])
    end
end
