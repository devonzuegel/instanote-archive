class User < ActiveRecord::Base
  has_one :evernote_account, dependent: :destroy
  has_one :instapaper_account, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  scope :fully_connected, -> () {
    all.select { |u| u.evernote_connected? && u.instapaper_connected? }
  }

  def self.sync_bookmarks
    fully_connected.each do |user|
      n_retrieved = user.retrieve_bookmarks.length
      n_stored    = user.save_bookmarks
      logger.info "> #{Time.now.to_s}: #{n_retrieved} bookmark(s) retrieved from Instapaper (user ##{user.id})"
      logger.info "> #{Time.now.to_s}: #{n_stored} bookmark(s) stored to Evernote (user ##{user.id})"
    end
  end

  def retrieve_bookmarks
    @in_client = InstapaperClient.new(instapaper_account)
    new_raw_bookmarks = @in_client.raw_bookmarks.select { |b| !Bookmark.already_saved?(b, self) }
    newly_saved = []
    new_raw_bookmarks.each do |raw_bkmk|
      newly_saved << Bookmark.create_from_bookmark(raw_bkmk, self)
    end
    newly_saved
  end

  def save_bookmarks
    ## TODO actually store it to Evernote now!
    bookmarks.select { |b| !b.stored }.count
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
