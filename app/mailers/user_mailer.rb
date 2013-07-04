#!/bin/env ruby
# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "mail@jiciben.com"
  def daily_mail(user_name, recipients)
  	@user_name = user_name
  	@recipients = recipients
  	@date = Time.now.strftime("%Y年%m月%d日")
  	mail(to: @recipients, subject: "Daily Mail of #{@date}, by @user_name")
  end
end
