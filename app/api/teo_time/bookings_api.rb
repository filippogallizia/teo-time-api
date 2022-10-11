module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      # /bookings/index
      desc 'List all bookings'
      get :index do
        # authenticate!
        # authorize! :read, Booking
        binding.pry
        Booking.all
      end

      # /bookings/create
      desc 'Create a booking'
      post :create do
        # authorize! :update, Booking
        Booking.create!(
          {
            user_id: params[:user_id],
            trainer_id: params[:trainer_id],
            start: params[:start].to_datetime,
            end: params[:end].to_datetime,
            event_id: params[:event_id],
            weekly_availability_id: params[:weekly_availability_id]
          }
        )
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "Bid id"
      end

      route_param :id do
        # /bookings/:id
        desc 'get single booking'
        get do
          # authenticate!
          # authorize! :read, Booking
          Booking.find(params[:id])
        end

        # /events/:id
        desc 'Edit event'
        put do
          # authenticate!
          # authorize! :update, Event
          # binding.pry
          booking = Booking.find(params[:id])
          # booking.update(weekly_availability_id: 1)
        end

        # /bookings/:id
        desc 'Delete booking'
        delete do
          # authenticate!
          # authorize! :update, Booking
          # binding.pry
          Booking.destroy(params[:id])
        end
      end
    end
  end
end