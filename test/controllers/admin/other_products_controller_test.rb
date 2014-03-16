require 'test_helper'

class Admin::OtherProductsControllerTest < ActionController::TestCase
  test "should get Admin" do
    get :Admin
    assert_response :success
  end

end
