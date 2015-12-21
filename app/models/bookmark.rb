class Bookmark < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  private

  def get_body()
    InstapaperClient.new(user.instapaper_account)
  end
end
