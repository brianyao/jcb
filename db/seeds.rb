# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Seed the jcb DB with some words.
more_words = [
  {:title => 'shuti', :in_chinese => 'zuoye',
  	:attempt_count => 0, :failed_count => 0, :add_date => '8-Jun-2013', :user_id => 1},
  {:title => 'kawayi', :in_chinese => 'keai',
  	:attempt_count => 0, :failed_count => 0, :add_date => '8-Jun-2013', :user_id => 1}
]
# NOTE: the following line temporarily allows mass assignment
# (needed if you used attr_accessible/attr_protected in word.rb)
Word.send(:attr_accessible, :title, :in_chinese, :attempt_count, :failed_count, :add_date)
more_words.each do |word|
  Word.create!(word)
end