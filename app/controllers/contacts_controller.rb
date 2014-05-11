class ContactsController < ApplicationController
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('header.navigation.contact')

    @designers = Designer.all
  end
end
