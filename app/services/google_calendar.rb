class GoogleCalendar
  def initialize
    @credentials = StringIO.new ENV['CREDENTIALS']
    @scopes = ['https://www.googleapis.com/auth/calendar']
    @client = Google::Auth::ServiceAccountJwtHeaderCredentials.make_creds(json_key_io: (StringIO.new ENV['CREDENTIALS']), scope: ['https://www.googleapis.com/auth/calendar'])
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = @client
    @calendar_id = ENV['FILO_CALENDAR_ID']
  end

  def calendars
    @calendar_list = @service.list_calendar_lists
    @calendar_list
  end

  def event (summary, location, description, start_time, end_time, time_zone)
    Google::Apis::CalendarV3::Event.new(
      {
        'summary': summary,
        'location': location,
        'description': description,
        'start': {
          'date_time': DateTime.parse(start_time),
          'time_zone': time_zone
        },
        'end': {
          'date_time': DateTime.parse(end_time),
          'time_zone': time_zone
        }
      })
  end

  def insert_event(event)
    @service.insert_event(@calendar_id, event)
  end
end