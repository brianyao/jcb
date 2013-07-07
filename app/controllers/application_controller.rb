#!/bin/env ruby
# encoding: utf-8
class ApplicationController < ActionController::Base
  # before_filter :set_current_user
  # protected # prevents method from being invoked by a route
  # def set_current_user
  #   # we exploit the fact that find_by_id(nil) returns nil
  #   @current_user ||= User.find_by_uid(session[:uid])
  #   #return unless @current_user
  #   flash[:error] = 'Error-- ' and return unless @current_user
  # end
  before_filter :require_login
 
  private
 
  def require_login
    @current_user ||= User.find_by_uid(session[:uid])
    unless @current_user
      flash[:error] = "请先登录从而使用记词本功能。"
      redirect_to '/' # halts request cycle
    end
  end

  public

  def check_user(model, entry_id)
    if model.find(entry_id).user_id != @current_user.id
      flash[:error] = "The resource that you requested does not belong to you!"
      redirect_to '/'
      return 'stop'
    else
      return 'pass'
    end
  end

end