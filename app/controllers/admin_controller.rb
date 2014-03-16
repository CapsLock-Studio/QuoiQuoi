class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def current_ability
    @current_ability = AdminAbility.new(current_admin)
  end
end