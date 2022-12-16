module TeoTime

  class EventsApi < Grape::API
    helpers TimeHelper
    resource :events do

      # /events
      desc 'List all events'
      params do
        optional :weekly_availability_id, type: Integer, allow_blank: false, desc: "weekly_availability_id"
      end
      get do
        authorize! :read, Event
        if params["weekly_availability"]
          Event.includes(:weekly_availability).filter_by_weekly_availability(params["weekly_availability"])
        else
          Event.includes(:weekly_availability).as_json
        end

      end

      params do
        requires :trainer_id, type: Integer, allow_blank: false, desc: "trainer_id"
        requires :name, type: String, allow_blank: false, desc: "name"
        requires :increment_amount, type: Integer, allow_blank: false, desc: "increment_amount"
        requires :duration, type: Integer, allow_blank: false, desc: "duration"
      end

      # /events/create
      desc 'Create a event'
      post do
        authorize! :update, Event
        Event.create!(
          {
            trainer_id: params[:trainer_id],
            name: params[:name],
            increment_amount: params[:increment_amount],
            duration: params[:duration],
          }
        )
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "id"
      end

      route_param :id do
        # /events/:id
        desc 'get single event'
        get do
          authorize! :read, Event
          Event.find(params[:id])
        end

        # /events/:id
        desc 'Delete event'
        delete do
          authenticate!
          authorize! :update, Event
          Event.destroy(params[:id])
        end

        # /events/:id
        desc 'Edit event'
        put do
          authenticate!
          authorize! :update, Event
          event = Event.find(params[:id])
          event.update(name: params[:name], duration: params[:duration], increment_amount: params[:increment_amount], trainer_id: params[:trainer_id])
        end

        # /events/:id/available_times
        desc 'Get available times'
        get 'available_times' do
          range_start = params[:start].to_datetime
          range_end = params[:end].to_datetime
          event = Event.find(params[:id])
          avail_on_the_fly = create_availability_on_the_fly(range_start, range_end, event)
          avail_on_the_fly.each { |av| av.compare_slots_with_bookings }
        end

        # /events/:id/bookings
        desc 'get single event'
        get 'bookings' do
          # authenticate!
          # authorize! :read, Event
          event = Event.find(params[:id])
          event.bookings.order(start: :asc)
        end

      end
    end
  end
end

# Get available slot times
# return value {
#   "day_id": 1,
#     "bookings": [
#     {
#       "start": "2022-11-28T12:30:00.000Z",
#       "end": "2022-11-28T13:30:00.000Z"
#     }
#   ],
#     "date": "2022-11-28T01:01:01.000+00:00",
#     "slots": [
#     {
#       "start": "2022-11-28T12:00:00.000+01:00",
#       "end": "2022-11-28T13:00:00.000+01:00"
#     },
#   ]
# }

#step 1 - avail_grouped_by_wday
#  {1=>
#    [
#     {:wday=>1,
#      :date=>Mon, 21 Nov 2022 01:01:01 +0000,
#      :range=>{:start=>Mon, 21 Nov 2022 01:01:01 +0000, :end=>Mon, 21 Nov 2022 23:59:00 +0000},
#      :slots=>[{:start=>Mon, 21 Nov 2022 12:00:00 CET +01:00, :end=>Mon, 21 Nov 2022 13:00:00 CET +01:00}]
#     }
#   ]
# }

#step 2 - bookings_inside_range_grouped_by_wday
# {1=>
#    [#<Booking:0x000000010e9da170
#      id: 17,
#      start: Mon, 21 Nov 2022 11:00:00 UTC +00:00,
#  end: Mon, 21 Nov 2022 12:00:00 UTC +00:00,
#  calendarEventId: "f9a4esdiqkobuc29njuhth7mfk",
#  created_at: Fri, 18 Nov 2022 14:20:30 UTC +00:00,
#  updated_at: Fri, 18 Nov 2022 14:20:30 UTC +00:00,
#  user_id: 2,
#  event_id: 8,
#  weekly_availability_id: 16,
#  trainer_id: 2,
#  time_zone: nil>]}