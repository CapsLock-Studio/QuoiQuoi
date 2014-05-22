class Admin::ArticleTypesController < AdminController
  authorize_resource
  before_action :set_article_type, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '文章種類管理', :admin_article_types_path

  # GET /admin/article_types
  # GET /admin/article_types.json
  def index
    @article_types = ArticleType.all
  end

  # GET /admin/article_types/1
  # GET /admin/article_types/1.json
  def show

  end

  # GET /admin/article_types/new
  def new
    add_breadcrumb '新增文章種類'

    @article_type = ArticleType.new
  end

  # GET /admin/article_types/1/edit
  def edit
    add_breadcrumb '修改文章種類'
  end

  # POST /admin/article_types
  # POST /admin/article_types.json
  def create
    @article_type = ArticleType.new(article_type_params)

    respond_to do |format|
      if @article_type.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @article_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/article_types/1
  # PATCH/PUT /admin/article_types/1.json
  def update
    respond_to do |format|
      if @article_type.update_attributes(article_type_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @article_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/article_types/1
  # DELETE /admin/article_types/1.json
  def destroy
    respond_to do |format|
      if @article_type.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_article_type
    @article_type = ArticleType.find(params[:id])
  end

  def article_type_params
    params.require(:article_type).permit(:id, :locale_id, :name)
  end
end
