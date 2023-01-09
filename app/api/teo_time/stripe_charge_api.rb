# require 'stripe'
module TeoTime

  class StripeChargeApi < Grape::API

    # // This is your Stripe CLI webhook secret for testing your endpoint locally.
    #   const endpointSecret = 'whsec_8191fe0ce40535369b354b20470c927cd8f56972068c683d228fbfc9a72ca2bf';
    #  const STRIPE_SECRET_TEST ='sk_test_51K5AW1G4kWNoryvxAZVOFwVPZ6qyVKUqZJslh0UYiNlU0aDb3hd0ksS0zCBWbyXUvDKB6f9CA9RvU3Gwc2rfBtsw00lC98E85E';
    resource 'payments' do
      params do
        requires :idempotency_key, type: String
        requires :event_id, type: String
      end

      post :create_payment_intent do
        authenticate!
        amount = Event.find(params[:event_id]).price
        begin
          customer = Stripe::Customer.list({ email: current_user.email })&.first || Stripe::Customer.create({ email: current_user.email, name: current_user.email }, { idempotency_key: params[:idempotency_key] })
          current_user.update!(stripe_customer_id: customer.id) if current_user.stripe_customer_id.nil?
          payment_intent = Stripe::PaymentIntent.create(
            {
              setup_future_usage: 'on_session',
              customer: customer.id,
              amount: amount,
              currency: 'eur',
              automatic_payment_methods: {
                enabled: true,
              },
            }
          )

          { clientSecret: payment_intent.client_secret }

        rescue Stripe::CardError => e
          #flash[:error] = e.message
          p error
          # redirect_to new_charge_path
        end
      end

      params do
        requires :transaction_id, type: String, allow_blank: false
        requires :status, type: String, allow_blank: false
      end

      post :complete do
        authenticate!
        Payment.create(user_id: current_user.id, transaction_id: params[:transaction_id], status: params[:status]) if Payment.find_by(transaction_id: params[:transaction_id]).nil?
      end
    end
  end
end
