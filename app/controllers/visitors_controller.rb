class VisitorsController < ApplicationController
  before_filter :authenticate_instapaper!, only: [ :bookmarks ]

  def index
  end

  def bookmarks
    current_user.bookmarks

    # en_client  = EvernoteClient.new(auth_token: current_user.evernote_account.auth_token)
    # @notebooks = en_client.notebooks
    # @notes     = en_client.notes

    # Bookmark.create_from_bookmark(@bookmarks.second, current_user)
    # en_client.note_from_bookmark(@bookmarks.second)
    # @bookmarks.each { |b| en_client.note_from_bookmark(b) }
  end

  private

  def authenticate_instapaper!
    if !user_signed_in?
      redirect_to root_url, alert: 'Please sign in or sign up.'
    elsif !current_user.instapaper_connected?
      redirect_to root_url, notice: 'Please connect your Instapaper account.'
    end
  end
end