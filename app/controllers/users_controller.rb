class UsersController < ApplicationController
  before_action :require_login, only: [:logout]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])

    if user
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      user = User.built_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Unable to log in: #{user.errors.messages}"
        redirect_to root_path
        return
      end
    end
    session[:user_id] = user.id
    redirect_to root_path
    return
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
