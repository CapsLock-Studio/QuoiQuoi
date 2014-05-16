class Admin::ArticlesController < AdminController
  authorize_resource
  before_action :set_article, except: [:index, :new, :create]
  before_action :delete_blank_article, except: [:update]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '文章管理', :admin_articles_path

  # GET /admin/articles
  # GET /admin/articles.json
  def index
    @articles = Article.all
  end

  # GET /admin/articles/1
  # GET /admin/articles/1.json
  def show

  end

  # GET /admin/articles/new
  def new
    add_breadcrumb '新增文章'

    @article = Article.new
    @article.save
  end

  # GET /admin/articles/1/edit
  def edit
    add_breadcrumb '修改文章'
  end

  # POST /admin/articles
  # POST /admin/articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/articles/1
  # PATCH/PUT /admin/articles/1.json
  def update
    respond_to do |format|
      if @article.update_attributes(article_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/articles/1
  # DELETE /admin/articles/1.json
  def destroy
    respond_to do |format|
      if @article.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:id, :article_type_id, :title, :content)
  end

  def delete_blank_article
    Article.where(article_type_id: [nil, '']).destroy_all
  end
end
