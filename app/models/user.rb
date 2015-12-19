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

  def connect_evernote(omniauth_response)
    auth_token       = omniauth_response['credentials']['token']
    evernote_account = EvernoteAccount.create(auth_token: auth_token, user: self)
  end

  def evernote_connected?
    !!evernote_account
  end

  def instapaper_connected?
    false
  end
end
