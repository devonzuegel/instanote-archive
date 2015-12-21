class InstapaperAccount < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  def expired?
    throw Exception
  end
end
