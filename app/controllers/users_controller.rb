class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: [:destroy]

  def new
    #空のUserインスタンスが呼びだされる
    @user = User.new
  end

  def index
    @users = User.where(activated:true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # micropostsをページネーションする為に必要
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      # flash[:success] = "Welcome to the Sample App!"
      # # 新規ユーザーが登録された時点でログインセッションを保持(8.25)
      # log_in @user
      # # redirect_to @user も同じ
      # redirect_to user_url(@user)

      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      # POSTされた状態で new.html.erbがレンダー
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  def patch
    @user = User.new
  end


  # user_paramsはクラス内のみで呼び出し可能
  private

    def user_params
      # 通して良いパラメータを表記
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # 正しいユーザーかどうかの確認
    def correct_user
      # idで一致を確認するのではなくuserで一致を確認
      @user = User.find(params[:id])
      redirect_to root_url unless @user == current_user
    end

    # adminユーザーかどうか？
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end

