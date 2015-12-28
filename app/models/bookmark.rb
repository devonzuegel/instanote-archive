class Bookmark < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates_uniqueness_of :bookmark_id, scope: :user_id

  scope :stored,       -> () { all.select { |b|  b.stored? } }
  scope :newly_synced, -> () { all.select { |b| !b.stored? } }

  def self.create_from_bookmark(bmk_obj, user)
    duplicates = where(bookmark_id: bmk_obj[:bookmark_id], user_id: user.id)
    return unless duplicates.empty?

    in_client = InstapaperClient.new(user.instapaper_account)
    attrs     = in_client.build_bookmark(bmk_obj)
    create(attrs.merge(user: user))
  end

  def self.already_saved?(raw_bookmark, user)
    duplicates = where(bookmark_id: raw_bookmark[:bookmark_id], user_id: user.id)
    duplicates.length > 0
  end

  def stored_to_evernote?
    !stored.nil?
  end

  def store_to_evernote!(en_client: en_client, safe: true)
    return if safe && stored_to_evernote?  # Don't save copies to Evernote
    puts "Storing note (id: #{id})"
    puts " > Title: #{title}"
    puts " > Url:   #{url}"
    stored_note = en_client.store_note_from_bookmark!(self)
    if stored_note.nil?
      puts " >> Note was not stored successfully. Cancelling..."
    else
      puts " >> Note stored successfully!"
      self.stored = Time.now
      self.save
    end
  end

  private
end
