class User < ActiveRecord::Base
  has_one :evernote_account, dependent: :destroy
  has_one :instapaper_account, dependent: :destroy

  scope :fully_connected, -> () {
    all.select { |u| u.evernote_connected? && u.instapaper_connected? }
  }

  def self.sync_bookmarks
    fully_connected.each do |user|
      ap user
    end
  end

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
    evernote_account = EvernoteAccount.create({
      auth_token: omniauth_response['credentials']['token'],
      user:       self
    })
  end

  def evernote_connected?
    !!evernote_account
  end

  def connect_instapaper(omniauth_response)
    instapaper_account = InstapaperAccount.create({
      username: omniauth_response['extra']['raw_info']['username'],
      secret:   omniauth_response['credentials']['secret'],
      token:    omniauth_response['credentials']['token'],
      user:     self
    })
  end

  def instapaper_connected?
    !!instapaper_account
  end
end
