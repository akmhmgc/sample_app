class UsersController < ApplicationController
  def new
    #空のUserインスタンスが呼びだされる
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      # 新規ユーザーが登録された時点でログインセッションを保持(8.25)
      log_in @user
      # redirect_to @user も同じ
      redirect_to user_url(@user)
    else
      # POSTされた状態で new.html.erbがレンダー
      render 'new'
    end
  end

  


  # user_paramsはクラス内のみで呼び出し可能
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

