class Admin::ContactYoutubeSlidesController < AdminController
  authorize_resource

  before_action :set_contact_youtube_slide, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '影片列表', :admin_contact_youtube_slides_path

  # GET /admin/contact_youtube_slides
  def index
    @contact_youtube_slides = ContactYoutubeSlide.order(:sort)
  end

  # GET /admin/contact_youtube_slides/new
  def new
    add_breadcrumb '新增影片'

    @contact_youtube_slide = ContactYoutubeSlide.new
  end

  # GET /admin/contact_youtube_slides/edit
  def edit
    add_breadcrumb '修改影片'

  end

  # POST /admin/contact_youtube_slides
  def create
    params = contact_youtube_slide_params.merge(sort: 1)

    contact_youtube_slides = ContactYoutubeSlide.order(:sort)

    unless contact_youtube_slides.last.nil?
      params[:sort] = (contact_youtube_slides.last.sort.to_i + 1)
    end

    @contact_youtube_slide = ContactYoutubeSlide.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @contact_youtube_slide.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/contact_youtube_slides/1
  def update
    respond_to do |format|
      if @contact_youtube_slide.update(contact_youtube_slide_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/contact_youtube_slides/1
  def destroy
    respond_to do |format|
      if @contact_youtube_slide.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/contact_youtube_slides/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      contact_youtube_slides = ContactYoutubeSlide.update(update_params[:contact_youtube_slides].keys, update_params[:contact_youtube_slides].values).reject{|p| p.errors.empty?}
      if contact_youtube_slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def contact_youtube_slide_params
      params.require(:contact_youtube_slide).permit(:id, :sort, :youtube)
    end
  
    def set_contact_youtube_slide
      @contact_youtube_slide = ContactYoutubeSlide.find(params[:id])
    end
  
    def update_params
      params.permit(contact_youtube_slides: [:id, :sort])
    end
end
