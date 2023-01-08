module TeoTime
  class API < Grape::API
    version 'v1', using: :header, vendor: 'teo_time'
    format :json

    class NotAuthenticated < StandardError
      def initialize(msg = nil)
        super("You are not authenticated")
      end
    end

    class NotAuthorized < StandardError
      def initialize(msg = nil)
        super("You are not authorized")
      end
    end

    class MethodNotFound < StandardError
    end

    class InvalidToken < StandardError
    end

    class InvalidCsrfToken < StandardError
    end

    rescue_from :all do |err|
      omit_backtrace = false
      response =
        case err
        when MethodNotFound
          omit_backtrace = true
          { status: 404, message: "Invalid API!" }
        when ActiveRecord::RecordNotFound
          { status: 404, message: "Record not found!" }
        when NotAuthenticated
          omit_backtrace = true
          { status: 401, message: err.message }
        when CanCan::AccessDenied
          omit_backtrace = true
          { status: 403, message: err.message || "You are not authorized" }
        when InvalidToken
          omit_backtrace = true
          { status: 401, message: "Invalid token" }
        when InvalidCsrfToken
          env['warden'].logout
          omit_backtrace = true
          { status: 401, message: "Invalid CSRF token" }
        when ActiveRecord::RecordNotUnique,
          ActiveRecord::StatementInvalid,
          Mysql2::Error
          { status: 400, message: "Please try again" }
        when ActiveRecord::ActiveRecordError
          validation_errors = err.try(:record).try(:errors).try(:messages)
          { status: 400, message: { error: err.message, errors: validation_errors } }
        when ArgumentError
          { status: 500, message: err.message }
        else
          { status: 500, message: err.message }
        end

      request = ::Rack::Request.new(env)
      log_data = {
        method: request.request_method,
        path: request.path,
        params: request.params.symbolize_keys.except(*Rails.application.config.filter_parameters),
        extra: (request.env["teoTime.extra"] || {}).merge(
          {
            error_class: err.class.name,
            error_message: err.message,
            error_backtrace: omit_backtrace ? ["OMITTED"] : err.backtrace
          }
        )
      }.merge(response)

      error!(response[:message], response[:status])
    end

    helpers do
      def warden
        env['warden']
      end

      def current_user
        @user || warden.user
      end

      def ability
        @ability ||= Ability.new(current_user)
      end

      def authenticate!
        raise NotAuthenticated unless current_user
      end

      def authenticated?
        return warden.authenticated? || @user.present?
      end

      def authorize!(*args)
        ability.authorize!(*args)
      end
    end

    mount TeoTime::BookingsApi
    mount TeoTime::EventsApi
    mount TeoTime::WeeklyAvailabilityApi
    mount TeoTime::HoursApi
    mount TeoTime::StripeChargeApi
    mount TeoTime::AvailabilityOverrideApi
    mount TeoTime::UsersApi
  end
end
