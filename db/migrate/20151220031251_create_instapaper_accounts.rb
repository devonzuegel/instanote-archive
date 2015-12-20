class CreateInstapaperAccounts < ActiveRecord::Migration
  def change
    create_table :instapaper_accounts do |t|
      t.string :token
      t.string :secret
      t.string :username
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
