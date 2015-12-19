class CreateEvernoteAccounts < ActiveRecord::Migration
  def change
    create_table :evernote_accounts do |t|
      t.string :auth_token

      t.timestamps null: false
    end
  end
end
