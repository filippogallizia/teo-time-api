module TeoTime
  class API < Grape::API
    version 'v1', using: :header, vendor: 'teo_time'
    format :json
    prefix :api

    class NotAuthenticated < StandardError
      def initialize(msg = nil)
        super("You are not authenticated")
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
          # when CanCan::AccessDenied
          #   omit_backtrace = true
          #   { status: 403, message: err.message || "You are not authorized" }
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
          # when Grape::Exceptions::ValidationErrors,
          #   Aws::SNS::MessageVerifier::VerificationError
          #   { status: 400, message: err.message }
        when ActiveRecord::ActiveRecordError
          validation_errors = err.try(:record).try(:errors).try(:messages)
          { status: 400, message: { error: err.message, errors: validation_errors } }
        when ArgumentError
          { status: 500, message: err.message }
        else
          { status: 500, message: err.message }
        end
    end

    helpers do
      def warden
        env['warden']
      end

      def current_user
        warden.user || warden.trainer
      end

      def authenticated
        if warden.authenticated?
          return true
        else
          error!('401 Unauthorized', 401)
        end
      end
    end

    mount TeoTime::BookingsApi

    # resource :bookings do
    #   desc 'Return a public timeline.'
    #   get :list do
    #     Booking.all if authenticated
    #   end
    #
    #   desc 'Create a booking.'
    #   # params do
    #   #   requires :status, type: String, desc: 'Your status.'
    #   # end
    #   post :create do
    #     # authenticate!
    #     Booking.create!(
    #       {
    #         user_id: 1,
    #         trainer_id: 2,
    #         start: params[:start],
    #         end: params[:end]
    #       }
    #     )
    #   end
    #
    #   desc 'Return a personal timeline.'
    #   get :home_timeline do
    #     # authenticate!
    #     current_user.statuses.limit(20)
    #   end
    # end
  end
end
