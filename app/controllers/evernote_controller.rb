class EvernoteController < ApplicationController
  before_filter :check_status

  def new
    redirect_to '/auth/evernote'
  end

  def create
    current_user.connect_evernote(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Evernote connected!'
  end

  private

  def check_status
    authenticate_user!
    if current_user.evernote_connected?
      redirect_to root_url, notice: 'You have already connected your Evernote account!'
    end
  end
end
