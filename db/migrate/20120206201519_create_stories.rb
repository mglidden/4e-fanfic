class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :body

      t.timestamps
    end
  end
end
