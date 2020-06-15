class UsersController < ApplicationController
  before_action :require_login, only: [:logout]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  # def login_form
  # end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
    if user
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      user = User.new(uid: auth_hash[:uid], provider: "github", username: auth_hash["extra"]["raw_info"]["login"], avatar: auth_hash["info"]["image"], email: auth_hash[""])
      if user.save
        session[:user_id] = user.id
        flash[:success] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Unable to log in"
      end
      redirect_to root_path
      return
    end
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
