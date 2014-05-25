class ReportsController < ApplicationController
  # GET /reports
  def index
    @registrations = Registration.where(email: params[:email], user_id: ['', nil])
  end

  # GET /reports/new
  def new

  end
end
