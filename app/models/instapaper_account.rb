class InstapaperAccount < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  def retrieve_bookmarks
    #
  end

  def save_bookmarks
    #
  end

  def expired?
    throw Exception
  end
end
