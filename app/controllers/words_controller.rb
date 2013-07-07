#!/bin/env ruby
# encoding: utf-8
class WordsController < ApplicationController
  before_filter :has_user, :except => [:index, :create]
  protected
  def has_user
    unless @current_user
      flash[:warning] = '请先登录从而使用记词本功能。'
      redirect_to word_path(params[:word_id])
    end
  end
  public

  def ji
    @words = Word.where("user_id = ?", @current_user).order(
      "(CASE WHEN attempt_count <> 0 THEN (failed_count / attempt_count) ELSE 0 END) DESC,
      updated_at").limit(20)
    if request.put? 
      @word = Word.find params[:id]
      @word.attempt_count += 1
      
      if params[:recall] == 'no'
        @word.failed_count += 1
        flash.now[:notice] = "😞忘记“#{@word.title}”+1"
      elsif params[:recall] == 'yes'        
        flash.now[:notice] = "😁记住“#{@word.title}”+1"
      else
        flash.now[:warning] = "Error on return recall value"
      end

      if @word.save
        flash.now[:notice] += "，并成功更新记录！"
      else
        flash.now[:notice] += "，而更新失败记录！"
      end
    end
  end

  def index
    @words = Word.where("user_id = ?", @current_user).order("updated_at DESC").limit(20)
  end

  def create
    @word = Word.new(params[:word])
    @word.user = @current_user
    @word.attempt_count = 0
    @word.failed_count = 0
    @sentence_id = params[:sentence_id]
    if @sentence_id
      @word.sentence_id = @sentence_id.to_i
    end
    if @word.save
      flash[:notice] = "成功将#{@word.title}加入记词本!"
      # flash[:notice] = "Added '#{@word.title}'!"
    else
      flash[:error] = 'Error:: '
      for error in @word.errors.full_messages
        flash[:error] += error
      end       
    end
    if @sentence_id 
      redirect_to sentence_path(@sentence_id.to_i)
    else
      redirect_to words_path
    end
  end

  def show
    unless self.check_user(Word, params[:id]) == 'stop'
      id = params[:id] # retrieve movie ID from URI route
      @word = Word.find(id) # look up movie by unique ID
      @recall = params[:recall]
      # will render app/views/movies/show.<extension> by default
    end
  end

  def edit
    unless self.check_user(Word, params[:id]) == 'stop'
      @word = Word.find params[:id]
      @word.updated_at = Time.now
      if @word.sentence_id
        @sentence = Sentence.find @word.sentence_id
      else
        @sentence = nil
      end
    end
  end

  def update
    unless self.check_user(Word, params[:id]) == 'stop'
      @word = Word.find params[:id]
      if @word.update_attributes params[:word]
        flash[:notice] = "“#{@word.title}”成功更新！"
        redirect_to words_path
      else
        flash[:error] = 'Error:: '
        for error in @word.errors.full_messages
          flash[:error] += error
        end
        redirect_to edit_word_path(@word)
      end
    end
  end

  def destroy
    unless self.check_user(Word, params[:id]) == 'stop'
      @word = Word.find(params[:id])
      @word.destroy
      flash[:notice] = "成功删除单词“#{@word.title}”！"
      redirect_to words_path
    end
  end

end