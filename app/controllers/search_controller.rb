class SearchController < ApplicationController
  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('search')

    @products = []
    @product_translates = ProductTranslate.includes(:product).where('lower(name) LIKE ? or lower(description) LIKE ?',
                                                                  "%#{params[:keyword].downcase}%",
                                                                  "%#{params[:keyword].downcase}%")
                                                             .where(products: {visible: true})
                                                             .where.not(name: nil, price: nil, products: {id: nil}).order(id: :desc)

    @course_translates = CourseTranslate.includes(:course).where('lower(name) LIKE ? or description LIKE ? or lower(teacher) LIKE ?',
                                                                "%#{params[:keyword].downcase}%",
                                                                "%#{params[:keyword].downcase}%",
                                                                "%#{params[:keyword].downcase}%")
                                                          .where(courses: {visible: true})
                                                          .where.not(name: nil, price: nil, courses: {id: nil}).order(id: :desc)


    @articles = Article.where('lower(title) LIKE ? or lower(content) LIKE ?', "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
    @travel_informations = TravelInformation.where('lower(title) LIKE ? or lower(content) LIKE ?', "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%").order(id: :desc)
  end
end
