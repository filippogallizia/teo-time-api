class Payment < ApplicationRecord
  belongs_to :user
  after_commit :send_confirmation_email, on: [:create]

  def send_confirmation_email
    begin
      PaymentMailer.confirm(self.user.email, self).deliver_now
    rescue
      puts '###PAYMENT_MAILER_ERROR###'
    end
  end
end
