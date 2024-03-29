class UsersController < ApplicationController
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
  	@users = User.paginate(page: params[:page], per_page: 2)
  end

  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page])
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
  		flash[:success] = "Profile successfully updated"
  		sign_in @user
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  def destroy
  	if current_user?(User.find(params[:id]))
  		redirect_with_error "LET'S NOT GO DELETING OURSELVES, KAY?"
  	else
		User.find(params[:id]).destroy
		flash[:success] = "User successfully destroyed"
		redirect_to users_path
	end
  end

  private
    def not_signed_in_user
    	redirect_with_error "You are not permitted to access that page" unless !signed_in?
    end

  	def correct_user
  		@user = User.find(params[:id])
		redirect_with_error "YO BITCH, WHAT THE FUCK ARE YOU DOING?" unless current_user?(@user)
  	end

	def admin_user
		redirect_with_error "I'M PRETTY SURE YOU'RE NOT AN ADMIN!!!!" unless current_user.admin?
	end
end
