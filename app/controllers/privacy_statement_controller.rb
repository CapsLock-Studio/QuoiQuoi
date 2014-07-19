class PrivacyStatementController < ApplicationController
  def show
    add_breadcrumb t('home'), root_path
    add_breadcrumb t('privacy_statement')
  end
end
