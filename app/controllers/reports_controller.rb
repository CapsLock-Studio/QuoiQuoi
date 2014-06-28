class ReportsController < ApplicationController
  # GET /reports
  def index
    @registrations = Registration.where(email: params[:email])
  end

  # GET /reports/new
  def new

  end
end