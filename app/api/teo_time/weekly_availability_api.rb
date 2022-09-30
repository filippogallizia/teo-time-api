module TeoTime
  class WeeklyAvailabilityApi < Grape::API
    resource :weekly_availabilities do

      # /weekly_availabilities/index
      desc 'List all weekly_availabilities'
      get :index do
        # authenticate!
        # authorize! :read, WeeklyAvailability
        WeeklyAvailability.all
      end

      params do
        requires :name, type: String, allow_blank: false, desc: "name"
      end

      # /weekly_availabilities/create
      desc 'Create a weekly_availability'
      post :create do
        # authorize! :update, WeeklyAvailability
        WeeklyAvailability.create!(
          {
            name: params[:name],
          }
        )
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "id"
      end

      route_param :id do
        # /weekly_availabilities/:id
        desc 'get single weekly_availability'
        get do
          # authenticate!
          # authorize! :read, WeeklyAvailability
          WeeklyAvailability.find(params[:id])
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