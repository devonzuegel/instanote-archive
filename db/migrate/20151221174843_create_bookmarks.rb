class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.text :description
      t.integer :bookmark_id
      t.string :title
      t.string :url
      t.boolean :starred
      t.string :type
      t.text :body
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
