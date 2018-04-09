class Mailer < ActionMailer::Base
  default :from => "Internal Notification <no-reply@3dsystems.com>",
    :reply_to => 'no-reply@3dsystems.com'
  layout 'mailer'

  def internal user, host
    subject = "Your credential is wrong."
    @user = user
    @host = host
    mail :to => [user.email], :subject => subject
  end
end
