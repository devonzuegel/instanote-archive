class User < ActiveRecord::Base
  has_one :evernote_account, dependent: :destroy

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ''
      end
    end
  end

  def evernote_connected?
    !!evernote_account
  end

  def instapaper_connected?
    false
  end
end
