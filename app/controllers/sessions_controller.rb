class SessionsController < ApplicationController
  def new
  end
  
  # postで渡されたデータの取り出し確認
  # def create
  #   @email = params[:session][:email]
  #   render 'name'
  # end

  def create 
    # テストが実行された後、インスタンス変数にはassignを利用することでアクセス可能(9.24)
    @instence_var = "instance!!"
    # 一意のemail adressによってユーザー情報を取得
    @user = User.find_by(email: params[:session][:email].downcase)
    # userが存在 かつ passwordによって認証されるかどうか
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        # paramsのチェックボックスが押されている場合はremember(user)を使用
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # flash.nowで現在のアクションのみ有効になる
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # logoutのアクション
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
