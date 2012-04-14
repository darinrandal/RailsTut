class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def index
  	@users = User.all
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def edit
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		flash[:success] = "You have successfully registered!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def update
  	if @user.update_attributes(params[:user])
  		flash[:success] = "Profile updated"
  		sign_in @user
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  private
  	def signed_in_user
  		unless signed_in?
  			store_location
  			redirect_to signin_path, error: "You must first sign in to access that page."
  		end
  	end

  	def correct_user
  		@user = User.find(params[:id])
  		unless current_user?(@user)
  			flash[:error] = "YO BITCH, WHAT THE FUCK ARE YOU DOING?"
  			redirect_to root_path
  		end
  	end
end
