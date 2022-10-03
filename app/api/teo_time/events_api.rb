module TeoTime

  class EventsApi < Grape::API
    helpers TimeHelper
    resource :events do

      # /events/index
      desc 'List all events'
      get :index do
        # authenticate!
        # authorize! :read, Event
        Event.all
      end

      params do
        requires :user_id, type: Integer, allow_blank: false, desc: "user_id"
        requires :weekly_availability_id, type: Integer, allow_blank: false, desc: "weekly_availability_id"
        requires :name, type: String, allow_blank: false, desc: "name"
        requires :increment_amount, type: Integer, allow_blank: false, desc: "increment_amount"
        requires :duration, type: Integer, allow_blank: false, desc: "duration"
      end

      # /events/create
      desc 'Create a event'
      post :create do
        # authorize! :update, Event
        Event.create!(
          {
            user_id: params[:user_id],
            name: params[:name],
            weekly_availability_id: params[:weekly_availability_id],
            increment_amount: params[:increment_amount],
            duration: params[:duration],
          }
        )
      end

      params do
        requires :id, type: Integer, allow_blank: false, desc: "id"
      end

      route_param :id do
        # /events/:id
        desc 'get single event'
        get do
          # authenticate!
          # authorize! :read, Event
          Event.find(params[:id])
        end

        # /events/:id
        desc 'Delete event'
        delete do
          # authenticate!
          # authorize! :update, Event
          # binding.pry
          Event.destroy(params[:id])
        end

        # /events/:id
        desc 'Edit event'
        put do
          # authenticate!
          # authorize! :update, Event
          # binding.pry
          event = Event.find(params[:id])
          event.update(weekly_availability_id: 1)
        end

        # /events/:id/available_times
        desc 'Get available slot times'
        get 'available_times' do
          rangeStart = params[:start].to_datetime
          rangeEnd = params[:end].to_datetime
          event = Event.find(3)

          avail_divided_by_date = divide_range_in_days({ start: rangeStart, end: rangeEnd }).each { |key, value| value.each { |hash|
            hash[:slots] = event.weekly_availability.hours.where(day_id: key).each_with_object([]) do |value, arr|
              arr << value.get_start_end2(hash[:date])
            end
                             .map { |v| create_slot([], event.increment_amount, event.duration, { start: v[:start], end: v[:end] }) }.flatten
          }
          }

          bookings_inside_range_grouped_by_day = event.bookings.inside_range({ start: rangeStart, end: rangeEnd }).group_by { |b| b.start.wday }

          bookings_inside_range_grouped_by_day.each_with_object([]) { |(day_id, bookings), array|
            avail_divided_by_date.each { |key, avail|
              if key == day_id
                bookings.each { |bkg|
                  avail.each { |avl|
                    if are_dates_equal?(avl[:date], bkg[:start])
                      array << {
                        bkg_start: bkg.start,
                        bkg_end: bkg.end,
                        date: avl[:date],
                        slots: avl[:slots].select { |slot|
                          overlaps?({ start: bkg[:start], end: bkg[:end] }, { start: slot[:start], end: slot[:end] }) == false }
                      }
                    end
                  }
                }
              end
            }
          }
        end
      end
    end
  end
end