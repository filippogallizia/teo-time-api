module TeoTime

  class EventsApi < Grape::API
    helpers TimeHelper
    resource :events do

      # /events/index
      desc 'List all events'
      get :index do
        # authenticate!
        # authorize! :read, Event
        Event.all
      end

      params do
        requires :user_id, type: Integer, allow_blank: false, desc: "user_id"
        requires :weekly_availability_id, type: Integer, allow_blank: false, desc: "weekly_availability_id"
        requires :name, type: String, allow_blank: false, desc: "name"
        requires :increment_amount, type: Integer, allow_blank: false, desc: "increment_amount"
        requires :duration, type: Integer, allow_blank: false, desc: "duration"
      end

      # /events/create
      desc 'Create a event'
      post :create do
        # authorize! :update, Event
        Event.create!(
          {
            user_id: params[:user_id],
            name: params[:name],
            weekly_availability_id: params[:weekly_availability_id],
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
          # authenticate!
          # authorize! :read, Event
          Event.find(params[:id])
        end

        # /events/:id
        desc 'Delete event'
        delete do
          # authenticate!
          # authorize! :update, Event
          # binding.pry
          Event.destroy(params[:id])
        end

        # /events/:id
        desc 'Edit event'
        put do
          # authenticate!
          # authorize! :update, Event
          # binding.pry
          event = Event.find(params[:id])
          event.update(weekly_availability_id: 1)
        end

        # /events/:id/available_times
        desc 'Get available slot times'
        get 'available_times' do
          rangeStart = params[:start].to_datetime
          rangeEnd = params[:end].to_datetime
          # (rangeStart..rangeEnd).group_by(&:wday)
          event = Event.find(3)
          weekly_event_slots = event.weekly_availability.group_hours_by_day.transform_values { |values|
            values.map { |v| create_slot([], event.increment_amount, event.duration, { start: v[:start], end: v[:end] }) }.flatten
          }
          bookings_inside_range = event.bookings.inside_range({ start: rangeStart, end: rangeEnd })
          yo = divide_range_in_days({ start: rangeStart, end: rangeEnd })
          binding.pry

          # binding.pry
          # bookings_inside_range
          # binding.pry
          # bookings = Booking.inside_range({ start: rangeStart, end: rangeEnd }, params[:id])
          # weekly_event_slots

          # r = availability_hours_grouped_for_day.map do |key, value|
          #   hash.values
          # end
          # r
          # bookings
          # bookings.group_by(&:wday)
          # bookings
        end

      end
    end
  end
end