class Word < ActiveRecord::Base
	validates :title, :presence => true
	validates :add_date, :presence => true
end