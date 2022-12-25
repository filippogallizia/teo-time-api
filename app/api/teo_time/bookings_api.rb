module TeoTime
  class BookingsApi < Grape::API
    resource :bookings do

      # GET /bookings
      desc 'List all bookings'
      get do
        # TODO is there a better way to do this?
        Booking.future_bookings.map { |booking| booking.custom_json }
      end

      # POST /bookings
      desc 'Create a booking'
      post do
        authenticate!
        authorize! :update, Booking

        booking = Booking.create!(
          {
            user_id: params[:user_id],
            trainer_id: params[:trainer_id],
            start: params[:start].to_datetime,
            end: params[:end].to_datetime,
            event_id: params[:event_id],
            weekly_availability_id: params[:weekly_availability_id],
            recurrent: params[:recurrent]
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
        # GET /bookings/:id
        desc 'get single booking'
        get do
          authenticate!
          authorize! :read, Booking
          Booking.find(params[:id])
        end

        # PUT /bookings/:id
        desc 'Edit bookings'
        put do
          authenticate!
          authorize! :update, Event
          booking = Booking.find(params[:id])
          # booking.update(weekly_availability_id: 1)
        end

        # DELETE /bookings/:id
        desc 'Delete booking'
        delete do
          authenticate!
          authorize! :update, Booking
          Booking.destroy(params[:id])
        end
      end

    end
  end
end