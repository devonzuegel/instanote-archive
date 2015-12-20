class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      !current_user.nil?
    end

    def correct_user?
      @user = User.find(params[:id])
      redirect_to root_url, alert: "Access denied." unless current_user == @user
    end

    def authenticate_user!
      redirect_to root_url, alert: 'Please sign in in order to access to this page.' if !current_user
    end

end
