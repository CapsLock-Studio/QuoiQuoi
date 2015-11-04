require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    # @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in User.first
  end

  # include ActiveJob::TestHelper
  # test "the truth" do
  #   assert true
  # end
  # test 'email is delivered with expected content' do
  #   perform_enqueued_jobs do
  #
  #   end
  # end
  test 'for first time' do
    get :index, use_route: :registrations_path
    assert_response :success
    assert_not_nil assigns(:registrations)
  end
end
