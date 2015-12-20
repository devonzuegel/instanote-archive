class VisitorsController < ApplicationController
  before_filter :authenticate_instapaper, only: [ :bookmarks ]

  def index
  end

  def bookmarks
    in_client  = InstapaperClient.new(current_user.instapaper_account)
    @bookmarks = []
    in_client.bookmarks.each { |b| @bookmarks << b }

    en_client  = EvernoteClient.new(auth_token: current_user.evernote_account.auth_token)
    @notebooks = en_client.notebooks
  end

  private

  def authenticate_instapaper
    if !user_signed_in?
      redirect_to root_url, notice: 'Please sign in or sign up.'
    elsif !current_user.instapaper_connected?
      redirect_to root_url, notice: 'Please connect your Instapaper account.'
    end
  end
end