class InstapaperController < ApplicationController
  before_filter :check_status

  def new
    redirect_to '/auth/instapaper'
  end

  def create
    current_user.connect_instapaper(request.env['omniauth.auth'])
    redirect_to root_url, notice: 'Instapaper connected!'
  end

  private

  def check_status
    authenticate_user!
    if current_user.instapaper_connected?
      redirect_to root_url, notice: 'You have already connected your Instapaper account!'
    end
  end
end
