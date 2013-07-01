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
    @words = Word.where("user_id = ?", @current_user).order("updated_at DESC").limit(20)
  end

  def index
    # @words = Word.order("add_date DESC").limit(20)
    @words = Word.where("user_id = ?", @current_user).order("updated_at DESC").limit(20)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @word = Word.find(id) # look up movie by unique ID
    @word.updated_at = Time.now
    # will render app/views/movies/show.<extension> by default
  end

  def create
    @word = Word.new(params[:word])
    @word.user = @current_user
    if @word.save
      # flash[:notice] = "成功将#{@word.title}加入记词本!"
      flash[:notice] = "Added '#{@word.title}'!"
    else
      flash[:error] = 'Error:: '
      for error in @word.errors.full_messages
        flash[:error] += error
      end       
    end
    redirect_to words_path
  end

  def edit
    @word = Word.find params[:id]
    @word.updated_at = Time.now
  end

  def update
  	@word = Word.find params[:id]
  	if @word.update_attributes params[:word]
  		flash[:notice] = "“#{@word.title}”成功更新！"
  		redirect_to words_path
  	else
      lash[:error] = 'Error:: '
      for error in @word.errors.full_messages
        flash[:error] += error
      end
  		redirect_to edit_word_path(@word)
  	end
  end

  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    flash[:notice] = "Word '#{@word.title}' deleted."
    redirect_to words_path
  end
end