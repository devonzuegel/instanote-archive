class InstapaperController < ApplicationController
  def new
    ap current_user
    if !user_signed_in?
      redirect_to root_url, notice: 'Please sign up or sign in!'
    elsif current_user.instapaper_connected?
      redirect_to root_url, notice: 'You have already connected your Instapaper account!'
    else
      redirect_to '/auth/instapaper'
    end
  end

  def create
    current_user.connect_instapaper(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Instapaper connected!'
  end
end
