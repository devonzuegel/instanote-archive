class CreateEvernoteAccounts < ActiveRecord::Migration
  def change
    create_table :evernote_accounts do |t|
      t.string :auth_token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
