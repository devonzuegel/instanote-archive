class VisitorsController < ApplicationController
  before_filter :authenticate_instapaper!, only: [ :bookmarks ]

  def index
  end

  def bookmarks
    in_client  = InstapaperClient.new(current_user.instapaper_account)
    @bookmarks = []
    in_client.bookmarks.each { |b| @bookmarks << b }  # Can't .map the bookmark list >:|

    en_client  = EvernoteClient.new(auth_token: current_user.evernote_account.auth_token)
    # @notebooks = en_client.notebooks
    # @notes     = en_client.notes

    # puts "@bookmarks.second[:text].length = #{@bookmarks.second[:text].length}".red
    en_client.note_from_bookmark(@bookmarks.second)
    # @bookmarks.each { |b| en_client.note_from_bookmark(b) }
  end

  private

  def authenticate_instapaper!
    authenticate_user!
    if !current_user.instapaper_connected?
      redirect_to root_url, notice: 'Please connect your Instapaper account.'
    end
  end
end