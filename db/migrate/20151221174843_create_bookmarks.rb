class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.text       :description
      t.integer    :bookmark_id
      t.string     :title
      t.string     :url
      t.boolean    :starred
      t.text       :body
      t.references :user, index: true, foreign_key: true
      t.timestamp  :progress_timestamp
      t.timestamp  :time
      t.float      :progress
      t.timestamp  :retrieved  # from instapaper
      t.timestamp  :stored     # to evernote

      t.timestamps null: false
    end
  end
end
