class RecruitmentsController < ApplicationController
  def show

    if flash[:status] == 'warning'
      flash[:message] = nil
    end

    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('recruitment')

    @requirement_intro = RequirementIntro.find(1)
    @requirements = Requirement.all
    @contact_us = ContactUs.new
  end
end