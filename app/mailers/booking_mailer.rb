class BookingMailer < ApplicationMailer
  def confirm(email, params)
    @params = params
    # default from: 'notifications@example.com'
    # @user = user
    mail(to: email, subject: 'Appuntamento prenotato')
  end

  def delete(email, params)
    @params = params
    # default from: 'notifications@example.com'
    # @user = user
    mail(to: email, subject: 'Appuntamento cancellato')
  end
end
