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
      t.timestamp  :retrieved, null: false, default: Time.now  # Time retrieved from instapaper
      t.timestamp  :stored                                     # Time saved to evernote

      t.timestamps null: false
    end

    # add_index :bookmarks, [:user_id, :bookmark_id], unique: true
  end
end
