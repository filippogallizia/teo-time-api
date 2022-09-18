module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      desc 'Return a public timeline.'
      get :list do
        Booking.all if authenticated
      end

      desc 'Create a booking.'
      # params do
      #   requires :status, type: String, desc: 'Your status.'
      # end
      post :create do
        # authenticate!
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