class CreateWords < ActiveRecord::Migration
  def up
    create_table :words do |t|
      t.string    :title
      t.string    :in_chinese
      t.integer   :attempt_count
      t.integer   :failed_count
      t.datetime  :add_date
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
  end

  def down
    drop_table :words
  end
end