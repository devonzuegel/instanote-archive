class Bookmark < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates_uniqueness_of :bookmark_id, scope: :user_id

  def self.create_from_bookmark(bmk_obj, user)
    duplicates = where(bookmark_id: bmk_obj[:bookmark_id], user_id: user.id)
    return unless duplicates.empty?

    in_client = InstapaperClient.new(user.instapaper_account)
    attrs     = in_client.build_bookmark(bmk_obj)
    create(attrs.merge(user: user))
  end

  def stored_to_evernote?
    !stored.nil?
  end

  def store_to_evernote(safe: true)
    return if safe && !store_to_evernote?  # Don't save copies to Evernote
    throw Exception  ## TODO store bookmark to Evernote
  end

  private

  def get_body()
    InstapaperClient.new(user.instapaper_account)
  end
end
