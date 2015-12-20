class CreateInstapaperAccounts < ActiveRecord::Migration
  def change
    create_table :instapaper_accounts do |t|
      t.string :token
      t.string :secret
      t.string :username

      t.timestamps null: false
    end
  end
end
