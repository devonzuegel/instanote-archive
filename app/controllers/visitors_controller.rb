class VisitorsController < ApplicationController
  def index
    if user_signed_in? && current_user.instapaper_connected?
      puts '----------------------------'
      InstapaperClient.new(current_user.instapaper_account)
      puts '----------------------------'
    end
  end
end