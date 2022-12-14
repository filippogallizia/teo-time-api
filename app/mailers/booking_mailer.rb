class BookingMailer < ApplicationMailer
  def confirm_booking(email)
    # default from: 'notifications@example.com'
    # @user = user
    mail(to: email, subject: 'Welcome to our website!')
  end
end
