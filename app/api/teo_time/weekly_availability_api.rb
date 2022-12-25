module TeoTime
  class WeeklyAvailabilityApi < Grape::API
    resource :weekly_availabilities do
      # /weekly_availabilities
      desc 'List all weekly_availabilities'
      get do
        # authenticate!
        # authorize! :read, WeeklyAvailability
        WeeklyAvailability.all
      end

      params do
        requires :address, type: String, allow_blank: true, desc: "event_id"
      end

      # /weekly_availabilities
      desc 'Create a weekly_availability'
      post do
        # authorize! :update, WeeklyAvailability
        WeeklyAvailability.create!(
          {
            name: params[:name],
            address: params[:address],
          }
        )
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "id"
        optional :name, type: String, desc: "name"
        optional :date, type: Boolean, desc: "If true we look for hours with a specific date (override)"
      end

      route_param :id do
        # /weekly_availabilities/:id
        desc 'get single weekly_availability'
        get do
          # authenticate!
          # authorize! :read, WeeklyAvailability
          WeeklyAvailability.find(params[:id]).as_json(include: [{ :availability_overrides => { :include => :hours } }, :hours])
        end

        put do
          # authenticate!
          # authorize! :read, WeeklyAvailability
          weekly_availability = WeeklyAvailability.find(params[:id])
          weekly_availability.update!(name: params[:name], address: params[:address])
        end

        # /weekly_availabilities/:id
        desc 'Delete weekly_availability'
        delete do
          # authenticate!
          # authorize! :update, WeeklyAvailability
          WeeklyAvailability.destroy(params[:id])
        end

      end
    end
  end
end