class Admin::SlidePositionsController < AdminController
  before_action :set_slide_position, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '輪播文字位置列表', :admin_slide_positions_path

  # GET /admin/slide_positions
  def index
    @slide_positions = SlidePosition.all
  end

  # GET /admin/slide_positions/new
  def new
    add_breadcrumb '新增輪播文字位置'

    @slide_position = SlidePosition.new
  end

  # GET /admin/slide_positions/edit
  def edit
    add_breadcrumb '修改輪播文字位置'
  end

  # POST /admin/slide_positions
  def create
    @slide_position = SlidePosition.new(slide_position_params)
    respond_to do |format|
      if @slide_position.save
        format.html {redirect_to action: :index, notice: 'Create Successed.'}
      else
        format.html {render action: :new}
      end
    end
  end

  # PUT/PATCH /admin/slide_positions/1
  def update
    respond_to do |format|
      if @slide_position.update(slide_position_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/slide_positions/1
  def destroy
    respond_to do |format|
      if @slide_position.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  private
    def set_slide_position
      @slide_position = SlidePosition.find(params[:id])
    end

    def slide_position_params
      params.require(:slide_position).permit(:id, :position, :image)
    end
end