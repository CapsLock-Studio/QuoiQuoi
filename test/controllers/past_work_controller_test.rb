require 'test_helper'

class PastWorkControllerTest < ActionController::TestCase
  test "should get completion_time:date" do
    get :completion_time:date
    assert_response :success
  end

  test "should get image:attachment" do
    get :image:attachment
    assert_response :success
  end

  test "should get visible:boolean" do
    get :visible:boolean
    assert_response :success
  end

  test "should get past_work_type:references" do
    get :past_work_type:references
    assert_response :success
  end

end
