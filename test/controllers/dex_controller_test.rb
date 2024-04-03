require "test_helper"

class DexControllerTest < ActionDispatch::IntegrationTest
  test "should get jup" do
    get home_url
    assert_response :success
  end
end
