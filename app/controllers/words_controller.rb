class WordsController < ApplicationController
  def index
    @words = Word.all
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @word = Word.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def create
    @word = Word.new(params[:word])
    if @word.save
      # flash[:notice] = "成功将#{@word.title}加入记词本!"
      flash[:notice] = "Added '#{@word.title}'!"
    end
    redirect_to words_path
  end

  def update
  	@word = Word.find params[:id]
  	if @word.update_attributes params[:word]
  		flash[:notice] = "#{@word.title} was updated!"
  		redirect_to words_path
  	else
  		render :partial => 'editing_form'
  	end
  end

  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    flash[:notice] = "Word '#{@word.title}' deleted."
    redirect_to words_path
  end
end