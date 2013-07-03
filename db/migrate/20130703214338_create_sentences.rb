class CreateSentences < ActiveRecord::Migration
  def up
    create_table :sentences do |t|
      t.text       :title
      t.text       :in_chinese
      t.timestamps
      t.references :user
    end
  end

  def down
  	 drop_table :sentences
  end
end
