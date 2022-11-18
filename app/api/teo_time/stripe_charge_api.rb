# require 'stripe'
module TeoTime

  class StripeChargeApi < Grape::API

    # // This is your Stripe CLI webhook secret for testing your endpoint locally.
    #   const endpointSecret = 'whsec_8191fe0ce40535369b354b20470c927cd8f56972068c683d228fbfc9a72ca2bf';
    #  const STRIPE_SECRET_TEST ='sk_test_51K5AW1G4kWNoryvxAZVOFwVPZ6qyVKUqZJslh0UYiNlU0aDb3hd0ksS0zCBWbyXUvDKB6f9CA9RvU3Gwc2rfBtsw00lC98E85E';
    resource 'payments' do
      params do
        requires :email, type: String
        requires :idempotency_key, type: String
      end

      post :create_payment_intent do
        @amount = 500
        begin
          customer = Stripe::Customer.list({ email: params[:email] })
          id = ''

          if customer.present? && customer.data.length > 0
            id = customer.data[0].id
          else
            id = Stripe::Customer.create({ email: params[:email] }, { idempotency_key: params[:idempotency_key] }).id
          end

          payment_intent = Stripe::PaymentIntent.create(
            {
              setup_future_usage: 'off_session',
              customer: id,
              amount: 50,
              currency: 'eur',
              automatic_payment_methods: {
                enabled: true,
              },
            }
          )

          { clientSecret: payment_intent.client_secret }

        rescue Stripe::CardError => e
          flash[:error] = e.message
          # redirect_to new_charge_path
        end
      end
    end
  end
end
