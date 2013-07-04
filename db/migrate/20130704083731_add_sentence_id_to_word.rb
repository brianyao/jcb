class AddSentenceIdToWord < ActiveRecord::Migration
  def change
  	add_column :words, :sentence_id, :integer
  end
end
