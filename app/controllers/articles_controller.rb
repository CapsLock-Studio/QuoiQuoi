class ArticlesController < ApplicationController
  def index

  end

  def show
    add_breadcrumb t('article')
    @article = Article.find(params[:id])
    @articles = Article.order(created_at: :desc).page(params[:page]).per(12)
    add_breadcrumb @article.article_type.name
  end
end
