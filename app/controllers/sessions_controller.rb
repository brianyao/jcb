#!/bin/env ruby
# encoding: utf-8
require "csv"
class Gen
  attr_accessor :file_name, :from, :to
  def parse_datetime_params params, label, utc_or_local = :local
      begin
        year   = params[(label.to_s + '(1i)').to_sym].to_i
        month  = params[(label.to_s + '(2i)').to_sym].to_i
        mday   = params[(label.to_s + '(3i)').to_sym].to_i
        hour   = (params[(label.to_s + '(4i)').to_sym] || 0).to_i
        minute = (params[(label.to_s + '(5i)').to_sym] || 0).to_i
        second = (params[(label.to_s + '(6i)').to_sym] || 0).to_i

        return DateTime.civil_from_format(utc_or_local,year,month,mday,hour,minute,second)
      rescue => exp
        return nil
      end
    end 
end

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
  
  def gen
    @gen =Gen.new
    if not params[:gen]      
      @gen.file_name = "宿題_" + Time.now.strftime("%Y年%m月%d日") + '_' + @current_user.name
      @gen.from = Time.now.ago(18.hours)
      @gen.to = Time.now
    else
      @gen.file_name = params[:gen][:file_name]
      @gen.from = @gen.parse_datetime_params(params[:gen], :from, Time.now.zone)
      @gen.to = @gen.parse_datetime_params(params[:gen], :to, Time.now.zone)
    end
    if params[:commit] == "察看结果"
      @sentences = Sentence.where(:created_at => @gen.from..@gen.to)
    elsif params[:commit] == "生成文件"
      @sentences = Sentence.where(:created_at => @gen.from..@gen.to)
        csv_string = CSV.generate do |csv| 
          # header row 
          csv << [nil, nil, "句子", nil, "单词"]
          csv << []
          # data rows 
          @sentences.each do |sentence|
            original_row = ['词句原文', nil, sentence.title, nil]
            translated_row =['中文解释',nil, sentence.in_chinese, nil]
            for word in sentence.words
              original_row.push(word.title)
              translated_row.push(word.in_chinese) 
            end
            csv << original_row
            csv << translated_row
            csv << []
        end
      end     
      # send it to the browser
      send_data csv_string, 
                :type => 'text/csv; charset=iso-8859-1; header=present', 
                :disposition => "attachment; filename=#{@gen.file_name}.csv"             
    end
  end

  def mail
    if params['recipients'].nil?
      flash[:notice] = "发给谁呢？"
    elsif (not params['recipients']['uself'].nil?) and (not params['my_email_adress'] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
      flash[:notice] = "请重新填的邮箱，#{params['my_email_adress']}看起来不对劲……"
    else
      recipients=[]
      recipients.push(params['my_email_adress']) if not params['recipients']['uself'].nil?
      recipients.push('914840618@qq.com') if not params['recipients']['admin'].nil?
      UserMailer.daily_mail(@current_user.name, recipients).deliver
      flash[:notice] = "已经发送邮件至：#{recipients}."
    end
  end
end
