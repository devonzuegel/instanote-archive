class InstapaperAccount < ActiveRecord::Base
  belongs_to :user

  def expired?
    throw Exception
  end
end
