module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      # /bookings/index
      desc 'List all bookings'
      get :index do
        # authenticate!
        # authorize! :read, Booking
        Booking.all
      end

      # /bookings/create
      desc 'Create a booking'
      post :create do
        # authorize! :update, Booking
        Booking.create!(
          {
            user_id: 1,
            trainer_id: 2,
            start: params[:start],
            end: params[:end]
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