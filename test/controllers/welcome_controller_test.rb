require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_index_url
    assert_response :success
  end
  test "should retain slots for returning RJs" do
    # Step 1
    # Create a new RJ
    rj = RadioJockey.create
    rj.member_type = "Returning DJ"
    rj.retaining = "Yes"
    rj.day = "Monday"
    rj.hour = 1
    rj.show_name = "Test Show"
    rj.last_name = "Test Last Name"
    rj.save
    process_returning_rj_retaining_their_slots
end
