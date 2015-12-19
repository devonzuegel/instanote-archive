class EvernoteController < ApplicationController

  def new
    redirect_to '/auth/evernote'
  end

  def create
    session[:auth_token] = request.env['omniauth.auth']['credentials']['token']
    puts '-----------------------------'.black
    ap session
    puts '-----------------------------'.black
    # auth = request.env['omniauth.auth']
    # user = User.where(provider: auth['provider'],
    #                   uid:      auth['uid'].to_s).first || User.create_with_omniauth(auth)
    redirect_to root_url, notice: 'Evernote connected!'
  end
end
