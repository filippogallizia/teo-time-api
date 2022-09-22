module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      desc 'List all bookings'
      get :list do
        authorize! :read, Booking
        Booking.all
      end

      desc 'Create a booking'
      post :create do
        authenticated
        authorize! :update, Booking
        Booking.create!(
          {
            user_id: 1,
            trainer_id: 2,
            start: params[:start],
            end: params[:end]
          }
        )
      end
    end
  end
end