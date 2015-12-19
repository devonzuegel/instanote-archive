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
    # auth = request.env['omniauth.auth']
    # user = User.where(provider: auth['provider'],
    #                   uid:      auth['uid'].to_s).first || User.create_with_omniauth(auth)
    redirect_to root_url, notice: 'Evernote connected!'
  end
end
