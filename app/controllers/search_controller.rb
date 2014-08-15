class SearchController < ApplicationController
  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('search')

    @products = []
    product_translates = ProductTranslate.where('name LIKE ? or description LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%").order(id: :desc)
    product_translates.each do |translate|
      if translate.price
        @products << translate.product
      end
    end

    @courses = []
    course_translates = CourseTranslate.where('name LIKE ? or description LIKE ? or teacher LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%").order(id: :desc)
    course_translates.each do |translate|
      if translate.price
        @courses << translate.course
      end
    end

    @articles = Article.where('title LIKE ? or content LIKE ?', "%#{params[:keyword]}%", "#{params[:keyword]}").order(id: :desc)
    @travel_informations = TravelInformation.where('title LIKE ? or content LIKE ?', "%#{params[:keyword]}%", "#{params[:keyword]}").order(id: :desc)
  end
end
