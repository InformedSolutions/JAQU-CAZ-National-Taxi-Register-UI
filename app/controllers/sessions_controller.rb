# frozen_string_literal: true

##
# Controller class for overwriting Devise methods.
#
class SessionsController < Devise::SessionsController
  ##
  # Called on user login.
  #
  # ==== Path
  #
  #    :POST /users/sign_in
  #
  # ==== Params
  # * +username+ - string, user email address
  # * +password+ - string, password submitted by the user
  #
  def create
    form = UsernameAndPassword.new(user_params[:username], user_params[:password])
    if form.valid?
      super
    else
      flash[:errors] = form.errors
      redirect_to new_user_session_path
    end
  end

  private

  # Returns the list of permitted params
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
