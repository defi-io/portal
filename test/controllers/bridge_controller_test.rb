require "test_helper"

class BridgeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bridge_index_url
    assert_response :success
  end
end
