module TeoTime

  class EventsApi < Grape::API
    helpers TimeHelper
    resource :events do

      # /events
      desc 'List all events'
      params do
        optional :weekly_availability_id, type: Integer, allow_blank: false, desc: "weekly_availability_id"
      end
      get do
        authorize! :read, Event
        if params["weekly_availability"]
          Event.includes(:weekly_availability).filter_by_weekly_availability(params["weekly_availability"])
        else
          Event.includes(:weekly_availability).as_json
        end

      end

      params do
        requires :trainer_id, type: Integer, allow_blank: false, desc: "trainer_id"
        requires :name, type: String, allow_blank: false, desc: "name"
        requires :increment_amount, type: Integer, allow_blank: false, desc: "increment_amount"
        requires :duration, type: Integer, allow_blank: false, desc: "duration"
      end

      # /events/create
      desc 'Create a event'
      post :new do
        authorize! :update, Event
        Event.create!(
          {
            trainer_id: params[:trainer_id],
            name: params[:name],
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
          authorize! :read, Event
          Event.find(params[:id])
        end

        # /events/:id
        desc 'Delete event'
        delete do
          authenticate!
          authorize! :update, Event
          Event.destroy(params[:id])
        end

        # /events/:id
        desc 'Edit event'
        put do
          authenticate!
          authorize! :update, Event
          event = Event.find(params[:id])
          event.update(name: params[:name], duration: params[:duration], increment_amount: params[:increment_amount], trainer_id: params[:trainer_id])
        end

        # /events/:id/available_times
        desc 'Get available times'
        get 'available_times' do
          rangeStart = params[:start].to_datetime
          rangeEnd = params[:end].to_datetime
          event = Event.find(params[:id])
          avail_grouped_by_wday = create_avail_divided_by_date(rangeStart, rangeEnd, event)
          # recurring bookings
          recurrent_bookings = event.bookings.where({ recurrent: true })
          recurring_bookings_with_updated_date = avail_grouped_by_wday.each_with_object([]) do |(day, range), array|
            recurrent_bookings.each do |book|
              if day === book[:start].wday
                range.each do |r|
                  array << book.give_date_to_recurrent_bookings(r, book)
                end
              end
            end
            array
          end
          # normal bookings
          bookings_inside_range_grouped_by_wday = event.bookings.where({ recurrent: nil }).inside_range({ start: rangeStart, end: rangeEnd })

          all_bookings_grouped_by_wday = [*recurring_bookings_with_updated_date, *bookings_inside_range_grouped_by_wday].group_by { |b| b.start.wday }

          if all_bookings_grouped_by_wday.size == 0
            avail_grouped_by_wday.each_with_object([]) { |(day, avail), array|
              avail.each { |avl|
                array << {
                  day_id: day,
                  bookings: [],
                  date: avl[:date],
                  slots: avl[:slots]
                }
              }
            }
          else
            all_bookings_grouped_by_wday.each_with_object([]) { |(bkg_day_id, bookings), array|
              avail_grouped_by_wday.each { |day, avail|
                if day == bkg_day_id
                  bookings.each { |bkg|
                    avail.each { |avl|
                      if are_dates_equal?(avl[:date], bkg[:start])
                        index = array.index { |ar| ar[:date] == avl[:date] }
                        if index
                          array[index] = {
                            **array[index],
                            bookings: array[index][:bookings] << { start: bkg[:start], end: bkg[:end] },
                            slots: array[index][:slots].select { |slot|
                              overlaps?({ start: bkg[:start], end: bkg[:end] }, { start: slot[:start], end: slot[:end] }) == false }
                          }
                        else
                          array << {
                            day_id: day,
                            bookings: [{ start: bkg[:start], end: bkg[:end] }],
                            date: avl[:date],
                            slots: avl[:slots].select { |slot|
                              overlaps?({ start: bkg[:start], end: bkg[:end] }, { start: slot[:start], end: slot[:end] }) == false }
                          }
                        end
                      else
                        array << {
                          day_id: day,
                          bookings: [],
                          date: avl[:date],
                          slots: avl[:slots]
                        }
                      end
                    }
                  }
                else
                  avail.each { |avl|
                    array << {
                      day_id: day,
                      bookings: [],
                      date: avl[:date],
                      slots: avl[:slots]
                    }
                  }
                end
              }
            }
          end
        end

        # /events/:id/bookings
        desc 'get single event'
        get 'bookings' do
          # authenticate!
          # authorize! :read, Event
          event = Event.find(params[:id])
          event.bookings.order(start: :asc)
        end

      end
    end
  end
end

# Get available slot times
# return value {
#   "day_id": 1,
#     "bookings": [
#     {
#       "start": "2022-11-28T12:30:00.000Z",
#       "end": "2022-11-28T13:30:00.000Z"
#     }
#   ],
#     "date": "2022-11-28T01:01:01.000+00:00",
#     "slots": [
#     {
#       "start": "2022-11-28T12:00:00.000+01:00",
#       "end": "2022-11-28T13:00:00.000+01:00"
#     },
#   ]
# }

#step 1 - avail_grouped_by_wday
#  {1=>
#    [
#     {:wday=>1,
#      :date=>Mon, 21 Nov 2022 01:01:01 +0000,
#      :range=>{:start=>Mon, 21 Nov 2022 01:01:01 +0000, :end=>Mon, 21 Nov 2022 23:59:00 +0000},
#      :slots=>[{:start=>Mon, 21 Nov 2022 12:00:00 CET +01:00, :end=>Mon, 21 Nov 2022 13:00:00 CET +01:00}]
#     }
#   ]
# }

#step 2 - bookings_inside_range_grouped_by_wday
# {1=>
#    [#<Booking:0x000000010e9da170
#      id: 17,
#      start: Mon, 21 Nov 2022 11:00:00 UTC +00:00,
#  end: Mon, 21 Nov 2022 12:00:00 UTC +00:00,
#  calendarEventId: "f9a4esdiqkobuc29njuhth7mfk",
#  created_at: Fri, 18 Nov 2022 14:20:30 UTC +00:00,
#  updated_at: Fri, 18 Nov 2022 14:20:30 UTC +00:00,
#  user_id: 2,
#  event_id: 8,
#  weekly_availability_id: 16,
#  trainer_id: 2,
#  time_zone: nil>]}