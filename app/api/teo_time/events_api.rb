module TeoTime
  class EventsApi < Grape::API
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
      end

      # /events/create
      desc 'Create a event'
      post :create do
        # authorize! :update, Event
        Event.create!(
          {
            user_id: params[:user_id],
            name: params[:name],
            weekly_availability_id: params[:weekly_availability_id]
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

        # /events/:id/available_times
        desc 'Get available slot times'
        get 'available_times' do
          rangeStart = params[:start].to_datetime
          rangeEnd = params[:end].to_datetime
          # (rangeStart..rangeEnd).group_by(&:wday)
          availability_hours_grouped_for_day = Event.find(2).weekly_availability.group_hours_by_day
          availability_hours_grouped_for_day
          # r = availability_hours_grouped_for_day.map do |key, value|
          #   hash.values
          # end
          # r
          # bookings = Booking.inside_range({ start: rangeStart, end: rangeEnd }, params[:id])
          # bookings
          # bookings.group_by(&:wday)
          # bookings
        end
      end
    end
  end
end