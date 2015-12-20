class InstapaperController < ApplicationController

  def new
    if user_signed_in? && current_user.instapaper_connected?
      redirect_to root_url, notice: 'You have already connected your Instapaper account!'
    else
      redirect_to '/auth/instapaper'
    end
  end

  def create
    ap request.env['omniauth.auth']['extra']['raw_info']
    ap request.env['omniauth.auth']['credentials']['secret']
    ap request.env['omniauth.auth']['credentials']['token']

    # current_user.connect_evernote(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Instapaper connected!'
  end
end
