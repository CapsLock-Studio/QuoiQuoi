class RecruitmentsController < ApplicationController
  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('recruitment')

    @requirement_intro = RequirementIntro.find(1)
    @requirements = Requirement.all
    @contact_us = ContactUs.new
  end
end