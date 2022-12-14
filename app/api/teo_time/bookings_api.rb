module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      # /bookings
      desc 'List all bookings'
      get do
        # authenticate!
        # authorize! :read, Booking
        # TODO is there a better way to do this?
        Booking.all.each_with_object([]) do |booking, array|
          hash = { **booking.attributes }
          hash['user'] = booking.user
          hash['trainer'] = booking.trainer
          hash['event'] = booking.event
          array << hash
        end
      end

      # /bookings
      desc 'Create a booking'
      post do
        authenticate!
        authorize! :update, Booking

        # Event has many weeklyAvailabilities, but for now we only use One event with One weeklyAvailability
        weekly_availability_id = Event.find(params[:event_id]).hours.first.weekly_availability_id
        booking = Booking.create!(
          {
            user_id: params[:user_id],
            trainer_id: params[:trainer_id],
            start: params[:start].to_datetime,
            end: params[:end].to_datetime,
            event_id: params[:event_id],
            weekly_availability_id: weekly_availability_id
          }
        )
        if booking.save
          BookingMailer.confirm_booking('galliziafilippo@gmail.com').deliver_now
        end
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "Bid id"
      end

      route_param :id do
        # /bookings/:id
        desc 'get single booking'
        get do
          authenticate!
          authorize! :read, Booking
          Booking.find(params[:id])
        end

        # /bookings/:id
        desc 'Edit bookings'
        put do
          authenticate!
          authorize! :update, Event
          # binding.pry
          booking = Booking.find(params[:id])
          # booking.update(weekly_availability_id: 1)
        end

        # /bookings/:id
        desc 'Delete booking'
        delete do
          authenticate!
          authorize! :update, Booking
          # binding.pry
          Booking.destroy(params[:id])
          'test'
        end
      end

      resource :users do

        desc 'Get booking for current_user'
        get :current_user do
          # binding.pry
          authenticate!
          Booking.where(user_id: current_user.id)
        end

        route_param :id do
          # /bookings/users/:id
          desc 'Get booking by user id'
          get do
            Booking.where(user_id: params[:id])
          end
        end

      end
    end
  end
end