module TeoTime
    class UsersApi < Grape::API
      helpers TimeHelper
      resource :users do
        params do
          optional :only_trainers, type: Boolean, allow_blank: true
        end

        get do
            # authenticate!
            raise NotAuthorized if current_user.is_client
            if params['only_trainers'] == 'true'
              respond_with User.where(role_id: 2)
            else
              respond_with User.all
            end
        end
  
        # /hours
        desc 'Create a hour'
        get 'bookings' do
          # authorize! :update, Event
          Booking.future_bookings.where(user_id: current_user.id).map { |booking| booking.custom_json }
        end

      end
    end
  end