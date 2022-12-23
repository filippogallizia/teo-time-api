module TeoTime

  class EventsApi < Grape::API
    helpers TimeHelper
    resource :events do
      # /events
      desc 'List all events'
      params do
        optional :include_weekly_availabilities, type: Boolean, allow_blank: true, desc: "trainer_id"
      end
      get do
        authorize! :read, Event
        if params[:include_weekly_availabilities].present?
          Event.all.each_with_object([]) do |event, array|
            hash = { **event.attributes }
            hash['weekly_availabilities'] = event.weekly_availabilities
            array << hash
          end
        else
          Event.all
        end
      end

      params do
        requires :trainer_id, type: Integer, allow_blank: false, desc: "trainer_id"
        requires :name, type: String, allow_blank: false, desc: "name"
        requires :increment_amount, type: Integer, allow_blank: false, desc: "increment_amount"
        requires :duration, type: Integer, allow_blank: false, desc: "duration"
        requires :price, type: Integer, allow_blank: false, desc: "duration"
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
            price: params[:price],
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
          event.update(name: params[:name], duration: params[:duration], increment_amount: params[:increment_amount], trainer_id: params[:trainer_id], price: params[:price])
        end

        # /events/:id/weekly_availability/:weekly_availability_id/available_times
        desc 'Get available times'
        resource "/weekly_availability" do
          route_param :weekly_availability_id do
            get 'available_times' do
              range_start = params[:start].to_datetime
              range_end = params[:end].to_datetime
              event = Event.find(params[:id])
              days = divide_range_in_days(range_start, range_end)
              days.map do |day|
                availability_on_the_fly = AvailabilityOnTheFly.new(
                  {
                    day_id: day.wday,
                    date: day,
                    weekly_availability_id: params[:weekly_availability_id],
                    range: { start: range_start, end: range_end },
                    event: event,
                    bookings: [],
                    recurrent_bookings: [],
                    slots: []
                  }
                )
                availability_on_the_fly.set_slots
                availability_on_the_fly.compare_slots_with_bookings
                availability_on_the_fly
              end
            end
          end
        end

        # /events/:id/bookings
        desc 'get single event'
        get 'bookings' do
          # authenticate!
          # authorize! :read, Event
          event = Event.find(params[:id])
          event.bookings.order(start: :asc)
        end

        desc 'Weekly availabilities'
        # /events/:id/weekly_availabilities
        get 'weekly_availabilities' do
          authorize! :read, Event
          event = Event.find(params[:id])
          event.weekly_availabilities
        end
      end
    end
  end
end