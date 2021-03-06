class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  helper_method def page
    [params[:page].to_i, 1].max
  end

  helper_method def full_layout?
    !!@full_layout
  end

  def login_user!(user)
    logout_user!
    session[:user_id] = user.id
  end

  def logout_user!
    @current_user = session[:user_id] = nil
  end

  helper_method def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find(session[:user_id])
      else
        User.new
      end
    end
  end

  helper_method def logged_in?
    current_user.persisted?
  end

  def require_not_logged_in!
    if logged_in? && !params[:force]
      redirect_to root_url and return
    end
  end

  def require_login!
    if !logged_in? || params[:force]
      session[:return_to] = request.original_fullpath
      redirect_to root_url, alert: I18n.t("application.login_required") and return
    end
  end

  def redirect_back_or_to(url = root_url, options = {})
    redirect_url = session.delete(:return_to) || url
    redirect_to redirect_url, options
  end
end
