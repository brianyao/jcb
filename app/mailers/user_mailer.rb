class UserMailer < ActionMailer::Base
  default from: "mail@jiciben.com"
  def daily_email(user, recipient, date)
  	@user = user
  	@recipient = recipient
  	@date = date
  	mail(to: @recipient, subject: "Daily Mail of #{@date}")
  end
end
