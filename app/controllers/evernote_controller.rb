class EvernoteController < ApplicationController

  def new
    if !user_signed_in?
      redirect_to root_url, notice: 'Please sign up or sign in!'
    elsif current_user.evernote_connected?
      redirect_to root_url, notice: 'You have already connected your Evernote account!'
    else
      redirect_to '/auth/evernote'
    end
  end

  def create
    current_user.connect_evernote(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Evernote connected!'
  end
end
