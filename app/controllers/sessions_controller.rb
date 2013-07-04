#!/bin/env ruby
# encoding: utf-8
class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :require_login, :only => [:home, :create]

  def home
    @current_user ||= User.find_by_uid(session[:uid])
  end

  def failure
  end

  def create
    # reset_session
    auth = request.env['omniauth.auth']
    # render :text => auth.inspect
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
      User.create_with_omniauth(auth)
    session[:uid] = user.uid
    redirect_to '/'
  end
  
  def destroy
    # reset_session
    session.delete(:uid)
    flash[:notice] = 'Logged out successfully.'
    redirect_to '/'
  end

  def admin
    @sentences = Sentence.all 
    @words = Word.all
  end

  def mail
    # if params['recipients'].nil?
    #   flash[:notice] = "发给谁呢？"
    # elsif (not params['recipients']['uself'].nil?) and (not params['my_email_adress'] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
    #   flash[:notice] = "请重新填的邮箱，#{params['my_email_adress']}看起来不对劲……"
    # else
    #   recipients=[]
    #   recipients.push(params['my_email_adress']) if not params['recipients']['uself'].nil?
    #   recipients.push('914840618@qq.com') if not params['recipients']['admin'].nil?
    #   UserMailer.daily_mail(@current_user.name, recipients).deliver
    #   flash[:notice] = "已经发送邮件至：#{recipients}."
    # end
  end
end
