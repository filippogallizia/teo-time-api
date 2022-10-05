require 'test_helper'

class BookingTest < ActionDispatch::IntegrationTest
  setup do
    @role = create(:role)
    @role_trainer = create(:role, name: "trainerr")
    @trainer = create(:user, email: "trainer@gmail.com", role: @role_trainer)
    @user = create(:user, email: "user@gmail.com", role: @role)
    @weekly_availability = create(:weekly_availability)
    @event = create(:event, user: @user, weekly_availability: @weekly_availability)
    # binding.pry
    @booking = FactoryBot.create(:booking, start: "2022-11-21T11:59:00.000Z", end: "2022-11-21T16:59:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    # @day = create(:day)
    # @hour = create(:hour, start: 480, end: 720, weekly_availability: @weekly_availability, day: @day)
    # @user = create(:user, role: @role)
  end

  test "the truth" do
    get 'http://localhost:3000/api/weekly_availabilities/index'
    p response.body, 'yoooo'
    assert true
  end
end
