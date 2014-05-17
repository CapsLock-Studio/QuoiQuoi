class ArticlesController < ApplicationController
  def index

  end

  def show
    add_breadcrumb t('article')
    @article = Article.find(params[:id])
    @articles = Article.order(created_at: :desc).page(params[:page]).per(12)
    @article_type_name = @article.article_type.article_type_translates.where(locale_id: session[:locale_id]).first.name
    add_breadcrumb @article_type_name
  end
end
