class PaymentMailer < ApplicationMailer
  def confirm(email, params)
    @params = params
    mail(to: email, subject: 'Pagamento andato a buon fine.')
  end
end
