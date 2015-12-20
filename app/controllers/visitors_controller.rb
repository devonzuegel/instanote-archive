class VisitorsController < ApplicationController
  before_filter :authenticate_, only: [ :bookmarks ]

  def index
  end

  def bookmarks
    client     = InstapaperClient.new(current_user.instapaper_account)
    @bookmarks = []
    client.bookmarks.each { |b| @bookmarks << b }
  end

  private

  def authenticate_
    if !current_user.instapaper_connected?
      redirect_to root_url, notice: 'Please connect your Instapaper account.'
    end
  end
end