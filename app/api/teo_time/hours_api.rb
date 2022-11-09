module TeoTime

  class HoursApi < Grape::API
    helpers TimeHelper
    resource :hours do
      params do
        requires :day_id, type: Integer, allow_blank: false, desc: "day_id"
        requires :event_id, type: Integer, allow_blank: false, desc: "event_id"
        requires :weekly_availability_id, type: Integer, allow_blank: false, desc: "weekly_availability_id"
        requires :time_zone, type: String, allow_blank: false, desc: "time_zone"
        requires :start, type: Integer, allow_blank: false, desc: "start"
        requires :end, type: Integer, allow_blank: false, desc: "end"
      end

      # /hours/new
      desc 'Create a hour'
      post :new do
        # authorize! :update, Event
        Hour.create!(
          {
            day_id: params[:day_id],
            time_zone: params[:time_zone],
            weekly_availability_id: params[:weekly_availability_id],
            start: params[:start],
            end: params[:end],
            event_id: params[:event_id]
          }
        )
      end
      params do
        requires :id, type: Integer, allow_blank: false, desc: "id"
        optional :start, type: Integer, desc: "start"
        optional :end, type: Integer, desc: "end"
        optional :event_id, desc: "event_id"
        optional :time_zone, type: String, desc: "time_zone"
      end

      route_param :id do
        desc 'Edit'
        put do
          hour = Hour.find(params[:id])
          hour.update!(start: params[:start], end: params[:end], event_id: params[:event_id], time_zone: params[:time_zone])
        end
      end

    end
  end
end