class EvernoteController < ApplicationController

  def new
    redirect_to '/auth/evernote'
  end

  def create
    session[:auth_token] = request.env['omniauth.auth']['credentials']['token']
    puts '-----------------------------'.black
    en_client = EvernoteClient.new(auth_token: session[:auth_token])
    ap en_client.notebooks
    puts '-----------------------------'.black
    redirect_to root_url, notice: 'Evernote connected!'
  end
end
