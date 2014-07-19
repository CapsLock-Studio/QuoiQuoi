class TermsOfServiceController < ApplicationController
  def show
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('terms_of_service')
  end
end
