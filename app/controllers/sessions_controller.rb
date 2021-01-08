class SessionsController < ApplicationController
  def new
  end
  
  # postで渡されたデータの取り出し確認
  # def create
  #   @email = params[:session][:email]
  #   render 'name'
  # end

  def create 
    # 一意のemail adressによってユーザー情報を取得
    user = User.find_by(email: params[:session][:email].downcase)
    # userが存在 かつ passwordによって認証されるかどうか
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      # flash.nowで現在のアクションのみ有効になる
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # logoutのアクション
  def destroy
    log_out
    redirect_to root_url
  end

end
