class WordsController < ApplicationController
  def index
    @words = Word.all
  end

  def create
  	@word = Word.create!(params[:word])
    flash[:notice] = "#{@word.title} was added!"
  end
end