require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get do_stuff" do
    get :do_stuff
    assert_response :success
  end

end
