class UsersController < ApplicationController
  def new
  	@user = User.new
  end
  
  def profile
  	redirect_to user_path(current_user)
  end

  def create
  	user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :city)
  	@user = User.new(user_params)
  	if @user.save
  		login @user
  		flash[:success] = "Sign up successfully. Welcome to CareForPet"
  		redirect_to account_path
  	else
  		flash[:danger] = "Email in use. Please try again."
		redirect_to welcome_path
	end
  end

  def index
  	@users = User.all
  end

  def show
  	@user = current_user
  end
  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		redirect_to user_path(current_user)
	  else
		  redirect_to edit_user_path(current_user)
	  end
  end

	def destroy
		@user.destroy()
	end

	private
	def set_user
		@user = current_user
	end

	def user_params 
		white_list = [
						:email, :email_confirmation,
						:password, :password_confirmation,
						:first_name, :last_name, :city
						]
		params.require(:user).permit(*white_list)
	end

end
