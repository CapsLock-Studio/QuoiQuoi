class Admin::IntroduceYoutubesController < AdminController
  authorize_resource

  before_action :set_introduce_youtube, except: [:index, :new, :create, :sort]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '影片列表', :admin_introduce_youtubes_path

  # GET /admin/introduce_youtubes
  def index
    @introduce_youtubes = IntroduceYoutube.order(:sort)
  end

  # GET /admin/introduce_youtubes/new
  def new
    add_breadcrumb '新增影片'

    @introduce_youtube = IntroduceYoutube.new
  end

  # GET /admin/introduce_youtubes/edit
  def edit
    add_breadcrumb '修改影片'

  end

  # POST /admin/introduce_youtubes
  def create
    params = introduce_youtube_params.merge(sort: 1)

    introduce_youtubes = IntroduceYoutube.order(:sort)

    unless introduce_youtubes.last.nil?
      params[:sort] = (introduce_youtubes.last.sort.to_i + 1)
    end

    @introduce_youtube = IntroduceYoutube.new(params)

    respond_to do |format|
      #format.html {render json: params}
      if @introduce_youtube.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/introduce_youtubes/1
  def update
    respond_to do |format|
      if @introduce_youtube.update(introduce_youtube_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/introduce_youtubes/1
  def destroy
    respond_to do |format|
      if @introduce_youtube.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/introduce_youtubes/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      introduce_youtubes = IntroduceYoutube.update(update_params[:introduce_youtubes].keys, update_params[:introduce_youtubes].values).reject{|p| p.errors.empty?}
      if introduce_youtubes.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def introduce_youtube_params
      params.require(:introduce_youtube).permit(:id, :sort, :youtube)
    end
  
    def set_introduce_youtube
      @introduce_youtube = IntroduceYoutube.find(params[:id])
    end
  
    def update_params
      params.permit(introduce_youtubes: [:id, :sort])
    end
end
