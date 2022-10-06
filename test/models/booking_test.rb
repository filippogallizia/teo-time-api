require 'test_helper'

class BookingTest < ActionDispatch::IntegrationTest
  setup do
    @increment = 100
    @duration = 60
    @role = create(:role)
    @role_trainer = create(:role, name: "trainer")
    @trainer = create(:user, email: "trainer@gmail.com", role: @role_trainer)
    @user = create(:user, email: "user@gmail.com", role: @role)
    @weekly_availability = create(:weekly_availability)
    @event = create(:event, user: @user, weekly_availability: @weekly_availability, increment_amount: @increment, duration: @duration)
  end

  test "if there are no bookings, first_slot_start = day_start and last_slot_end = day_end" do
    required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-18T21:00:00.000Z' }
    day = create(:day, name: 'wednesday', id: 5)
    weekly_availability = create(:weekly_availability)
    event = create(:event, user: @user, weekly_availability: weekly_availability)
    create(:hour, start: 480, end: 720, weekly_availability: weekly_availability, day: day)
    create(:hour, start: 780, end: 1200, weekly_availability: weekly_availability, day: day)
    # @booking = FactoryBot.create(:booking, start: "2022-11-21T11:59:00.000Z", end: "2022-11-21T16:59:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    get "http://localhost:3000/api/events/#{event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
    res = response.body
    day_of_work = JSON.parse(res).select { |d| d['day_id'] == day.id }[0]
    working_start = required_range[:start].to_datetime.at_beginning_of_day + 480.minutes
    slot_one_start = day_of_work['slots'].first["start"].to_datetime
    working_end = required_range[:start].to_datetime.at_beginning_of_day + 1200.minutes
    last_slot_end = day_of_work['slots'].last["end"].to_datetime
    # assert there are no bookings
    assert_equal day_of_work['bookings'].size, 0
    # assert there are 8 element in array, it means all of them
    assert_equal day_of_work['slots'].size, 8
    # assert working start time
    assert_equal slot_one_start, working_start
    # assert working end time
    assert_equal last_slot_end, working_end
  end

  test "test event increment and duration" do
    required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-18T21:00:00.000Z' }
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 480, end: 720, weekly_availability: @weekly_availability, day: day)
    create(:hour, start: 780, end: 1200, weekly_availability: @weekly_availability, day: day)
    # @booking = FactoryBot.create(:booking, start: "2022-11-21T11:59:00.000Z", end: "2022-11-21T16:59:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
    res = response.body

    day_of_work = JSON.parse(res).select { |d| d['day_id'] == day.id }[0]
    slot_one_start = day_of_work['slots'].first["start"].to_datetime
    slot_one_end = day_of_work['slots'].first["end"].to_datetime
    slot_two_start = day_of_work['slots'][1]["start"].to_datetime
    # assert increment
    assert_equal slot_one_end + @increment.minutes, slot_two_start
    # assert duration
    assert_equal slot_one_start + @duration.minutes, slot_one_end
  end

  #todo test with bookings
end
