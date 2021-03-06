class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user , only: [:edit , :update, :destroy]
  before_action :require_admin , only: [:destroy]
  def new
    @user = User.new
  end
  def index
    @users = User.paginate(page: params[:page],per_page: 5)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] ="successfully signed up"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit

  end
  
  def update
    
    if @user.update(user_params)
      flash[:success] ="successfully updated account"
      redirect_to articles_path
    else
      rener 'edit'
    end 
        
  end
  
  
  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all articles created by the user have been deleted"
    if(@user.id == session[:id])
      session[:id] = nil
    end
    redirect_to root_path
  end


  private 
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_same_user
    if  current_user != @user && !current_user.admin?
      flash[:danger] = "You can edit your own account only"
      redirect_to root_path
    end
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admin users can perform this action"
      redirect_to root_path
    end
  end
end