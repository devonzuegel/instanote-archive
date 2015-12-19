class EvernoteController < ApplicationController

  def new
    if user_signed_in? && current_user.evernote_connected?
      redirect_to root_url, notice: 'You have already connected your Evernote account!'
    else
      redirect_to '/auth/evernote'
    end
  end

  def create
    session[:auth_token] = request.env['omniauth.auth']['credentials']['token']
    puts '============================='.black
    en_client = EvernoteClient.new(auth_token: session[:auth_token])
    ap session
    puts '-----------------------------'.black
    ap request.env['omniauth.auth']['extra']['access_token']
    puts '============================='.black
    redirect_to root_url, notice: 'Evernote connected!'
  end
end
