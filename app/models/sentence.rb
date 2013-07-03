class Sentence < ActiveRecord::Base
  belongs_to :user
  has_many :words
  attr_protected :user_id
end