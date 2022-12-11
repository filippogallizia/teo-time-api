module TeoTime
  class AvailabilityOverrideApi < Grape::API
    resource :availability_overrides do

      params do
        requires :start_date, type: Date
        requires :end_date, type: Date
        requires :weekly_availability_id, type: Integer
      end

      # GET /availability_overrides
      get do
        # authenticate!
        # authorize! :read, WeeklyAvailability
        AvailabilityOverride.all
      end

      # POST /availability_overrides
      post do

        # authenticate!
        # authorize! :read, WeeklyAvailability
        AvailabilityOverride.create!(
          {
            start_date: params[:start_date],
            end_date: params[:end_date],
            weekly_availability_id: params[:weekly_availability_id],
          }
        )
      end
      route_param :id do
        # PUT /availability_overrides
        put do
          # authenticate!
          # authorize! :read, WeeklyAvailability
          availability_override = AvailabilityOverride.find(params[:id])
          availability_override.update(start_date: params[:start_date], end_date: params[:end_date], weekly_availability_id: params[:weekly_availability_id])
        end

        # DELETE /availability_overrides
        delete do
          # authenticate!
          # authorize! :update, WeeklyAvailability
          AvailabilityOverride.destroy(params[:id])
        end
      end
    end
  end
end