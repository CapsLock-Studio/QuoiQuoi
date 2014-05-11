class RequirementsController < ApplicationController
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('header.navigation.requirement')

    @requirement_intro = RequirementIntro.find(1)
    @requirements = Requirement.all
  end
end