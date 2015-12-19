class AddEvernoteAccountToUser < ActiveRecord::Migration
  def change
    add_reference :users, :evernote_account, index: true, foreign_key: true
  end
end
