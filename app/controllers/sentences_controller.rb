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
    unless self.check_user(Sentence, params[:id]) == 'stop'
      @sentence_id = params[:id]
      @sentence = Sentence.find @sentence_id
      @words = Word.where("sentence_id = ?", @sentence).order("updated_at DESC")
    end
  end

  def create
    @sentence = Sentence.new(params[:sentence])
    @sentence.user = @current_user
    if @sentence.save
      flash[:notice] = "成功将句子“#{@sentence.title}”加入记词本!"
      if params[:commit] == "添加句子"
        redirect_to sentences_path
      elsif params[:commit] == "添加并连接单词"
        redirect_to sentence_path(@sentence)
      end
    else
      flash[:error] = 'Error:: '
      for error in @sentence.errors.full_messages
        flash[:error] += error
      end
      redirect_to sentences_path       
    end
  end

  def edit
    unless self.check_user(Sentence, params[:id]) == 'stop'
      @sentence = Sentence.find params[:id]
      @sentence.updated_at = Time.now
    end
  end

  def update
    unless self.check_user(Sentence, params[:id]) == 'stop'
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
  end

  def destroy
    unless self.check_user(Sentence, params[:id]) == 'stop'
      @sentence = Sentence.find(params[:id])
      @words = Word.where("sentence_id = ?", @sentence)
      for word in @words
        word.sentence_id = nil
        word.save
      end
      @sentence.destroy
      flash[:notice] = "成功删除句子“#{@sentence.title}”并去除相关单词链接！"
      redirect_to sentences_path
    end
  end

end