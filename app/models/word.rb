class Word < ActiveRecord::Base
	belongs_to :user
	validates :title, :presence => true
	validates :add_date, :presence => true
end