require 'test_helper'

class BookingTest < ActionDispatch::IntegrationTest
  setup do
    @monday = '2022-11-14T00:00:00.000Z'
    @tuesday = '2022-11-15T00:00:00.000Z'
    @wednesday = '2022-11-16T00:00:00.000Z'
    @thursday = '2022-11-17T00:00:00.000Z'
    @friday = '2022-11-18T00:00:00.000Z'
    @saturday = '2022-11-19T00:00:00.000Z'
    @sunday = '2022-11-20T00:00:00.000Z'
    @increment = 30
    @duration = 60
    @role = create(:role)
    @role_trainer = create(:role, name: "trainer")
    @trainer = create(:user, email: "trainer@gmail.com", role: @role_trainer)
    @user = create(:user, email: "user@gmail.com", role: @role)
    @weekly_availability = create(:weekly_availability)
    @event = create(:event, user: @user, weekly_availability: @weekly_availability, increment_amount: @increment, duration: @duration)
  end

  # test "if there are no bookings, first_slot_start = day_start and last_slot_end = day_end" do
  #   required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-18T21:00:00.000Z' }
  #   day = create(:day, name: 'wednesday', id: 5)
  #   weekly_availability = create(:weekly_availability)
  #   event = create(:event, user: @user, weekly_availability: weekly_availability)
  #   create(:hour, start: 480, end: 720, weekly_availability: weekly_availability, day: day, time_zone: 'Europe/Rome')
  #   create(:hour, start: 780, end: 1200, weekly_availability: weekly_availability, day: day, time_zone: 'Europe/Rome')
  #   get "http://localhost:3000/api/events/#{event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
  #   res = response.body
  #   day_of_work = JSON.parse(res).select { |d| d['day_id'] == day.id }[0]
  #   working_start = required_range[:start].to_datetime.at_beginning_of_day + 480.minutes
  #   slot_one_start = day_of_work['slots'].first["start"].to_datetime
  #   working_end = required_range[:start].to_datetime.at_beginning_of_day + 1200.minutes
  #   last_slot_end = day_of_work['slots'].last["end"].to_datetime
  #   # assert there are no bookings
  #   assert_equal day_of_work['bookings'].size, 0
  #   # assert there are 8 element in array, it means all of them
  #   assert_equal day_of_work['slots'].size, 8
  #   binding.pry
  #   # assert working start time
  #   assert_equal slot_one_start, working_start
  #   # assert working end time
  #   assert_equal last_slot_end, working_end
  # end

  test "test event increment and duration" do
    required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-18T21:00:00.000Z' }
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 480, end: 720, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')
    create(:hour, start: 780, end: 1200, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')

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

  test "test av_start > booking_finish" do
    required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-18T21:00:00.000Z' }
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 8 * 60, end: 12 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')
    create(:hour, start: 13 * 60, end: 20 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')

    @booking = FactoryBot.create(:booking, start: "2022-11-18T08:00:00.000Z", end: "2022-11-18T09:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
    res = response.body
    day_of_work = JSON.parse(res).select { |d| d['day_id'] == day.id }[0]
    slot_one_start = day_of_work['slots'].first["start"].to_datetime
    # av start after booking finish
    assert slot_one_start > "2022-11-18T08:59:00.000Z".to_datetime
  end

  test "test range of 7 days returns 7 days" do
    required_range = { start: week_days_with_datetime(:monday), end: week_days_with_datetime(:sunday) }
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 8 * 60, end: 12 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')
    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
    res = JSON.parse(response.body)
    assert_equal res.size, 7
  end

  test "test no hours, no slots" do
    required_range = { start: week_days_with_datetime(:monday), end: week_days_with_datetime(:sunday) }
    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"
    res = JSON.parse(response.body)
    res.each { |day| assert day['slots'].length, 0 }
  end

  test "test full booked, no slots" do
    required_range = { start: week_days_with_datetime(:monday), end: week_days_with_datetime(:sunday) }
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 8 * 60, end: 12 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')
    create(:hour, start: 13 * 60, end: 20 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')

    @booking = FactoryBot.create(:booking, start: "2022-11-18T08:00:00.000Z", end: "2022-11-18T09:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T09:30:00.000Z", end: "2022-11-18T10:30:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T11:00:00.000Z", end: "2022-11-18T12:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T13:00:00.000Z", end: "2022-11-18T14:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T14:30:00.000Z", end: "2022-11-18T15:30:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T16:00:00.000Z", end: "2022-11-18T17:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T17:30:00.000Z", end: "2022-11-18T18:30:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)
    @booking = FactoryBot.create(:booking, start: "2022-11-18T19:00:00.000Z", end: "2022-11-18T20:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer)

    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"

    res = JSON.parse(response.body)
    res.each { |day| assert day['slots'].length, 0 if day['day_id'] == 5 }
  end

  test "test return error if booking is not compatible with slot" do
    day = create(:day, name: 'wednesday', id: 5)
    create(:hour, start: 8 * 60, end: 12 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Europe/Rome')
    b = Booking.create({ start: "2022-11-18T08:00:00.000Z", end: "2022-11-18T12:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer })
    assert_equal b.errors.messages[:'Slot missing'][0], "There is not a slot for this booking range"
  end

  test "test time zone" do
    required_range = { start: '2022-11-18T06:00:00.000Z', end: '2022-11-19T08:00:00.000Z' }
    day = create(:day, name: 'wednesday', id: 5)

    create(:hour, start: 8 * 60, end: 12 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Samara')
    create(:hour, start: 13 * 60, end: 20 * 60, weekly_availability: @weekly_availability, day: day, time_zone: 'Samara')

    b = Booking.create({ start: "2022-11-18T07:00:00.000Z", end: "2022-11-18T08:00:00.000Z", event: @event, weekly_availability: @weekly_availability, user: @user, trainer: @trainer })

    get "http://localhost:3000/api/events/#{@event.id}/available_times?start=#{required_range[:start]}&end=#{required_range[:end]}"

    res = JSON.parse(response.body)
    binding.pry
    day_of_work = res.select { |d| d['day_id'] == day.id }[0]
    slot_one_start = day_of_work['slots'].first["start"].to_datetime

  end
end
