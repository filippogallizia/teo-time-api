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
        requires :name, type: String, allow_blank: false, desc: "name"
      end

      # /weekly_availabilities/new
      desc 'Create a weekly_availability'
      post :new do
        # authorize! :update, WeeklyAvailability
        WeeklyAvailability.create!(
          {
            name: params[:name],
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
          WeeklyAvailability.find(params[:id]).as_json(include: :hours)
        end

        put do
          # authenticate!
          # authorize! :read, WeeklyAvailability
          weekly_availability = WeeklyAvailability.find(params[:id])
          weekly_availability.update(name: params[:name])
        end

        # /weekly_availabilities/:id
        desc 'Delete weekly_availability'
        delete do
          # authenticate!
          # authorize! :update, WeeklyAvailability
          # binding.pry
          WeeklyAvailability.destroy(params[:id])
        end

      end
    end
  end
end