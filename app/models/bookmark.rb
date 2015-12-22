class Bookmark < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  def self.create_from_bookmark(bmk_obj, user)
    in_client = InstapaperClient.new(user.instapaper_account)
    attrs     = in_client.build_bookmark(bmk_obj)
    puts '=== attrs: =============================================================='.black
    ap attrs
    puts '========================================================================='.black
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
