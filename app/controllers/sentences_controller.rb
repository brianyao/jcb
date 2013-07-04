#!/bin/env ruby
# encoding: utf-8
class SentencesController < ApplicationController
  before_filter :has_user, :except => [:index, :create]
  protected
  def has_user
    unless @current_user
      flash[:warning] = '请先登录从而使用记词本功能。'
      redirect_to sentence_path(params[:sentence_id])
    end
  end
  public

  def index
    @sentences = Sentence.where("user_id = ?", @current_user).order("updated_at DESC").limit(20)
  end

  def show
    @sentence_id = params[:id]
    @sentence = Sentence.find @sentence_id
    @words = Word.where("sentence_id = ?", @sentence).order("updated_at DESC")
  end

  def create
    @sentence = Sentence.new(params[:sentence])
    @sentence.user = @current_user
    if @sentence.save
      flash[:notice] = "成功将#{@sentence.title}加入记词本!"
    else
      flash[:error] = 'Error:: '
      for error in @sentence.errors.full_messages
        flash[:error] += error
      end       
    end
    redirect_to sentences_path
  end

  def edit
    @sentence = Sentence.find params[:id]
    @sentence.updated_at = Time.now
  end

  def update
    @sentence = Sentence.find params[:id]
    if @sentence.update_attributes params[:sentence]
      flash[:notice] = "“#{@sentence.title}”成功更新！"
      redirect_to sentences_path
    else
      flash[:error] = 'Error:: '
      for error in @sentence.errors.full_messages
        flash[:error] += error
      end
      redirect_to edit_sentence_path(@sentence)
    end
  end

  def destroy
    @sentence = Sentence.find(params[:id])
    @sentence.destroy
    flash[:notice] = "Sentence '#{@sentence.title}' deleted."
    redirect_to sentences_path
  end
end