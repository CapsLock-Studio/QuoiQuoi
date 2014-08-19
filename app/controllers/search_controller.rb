class SearchController < ApplicationController
  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('search')

    @products = []
    product_translates = ProductTranslate.where('lower(name) LIKE ? or lower(description) LIKE ?', "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
    product_translates.each do |translate|
      if translate.price
        @products << translate.product
      end
    end

    @courses = []
    course_translates = CourseTranslate.where('lower(name) LIKE ? or description LIKE ? or lower(teacher) LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
    course_translates.each do |translate|
      if translate.price
        @courses << translate.course
      end
    end

    @articles = Article.where('lower(title) LIKE ? or lower(content) LIKE ?', "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
    @travel_informations = TravelInformation.where('lower(title) LIKE ? or lower(content) LIKE ?', "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
  end
end
