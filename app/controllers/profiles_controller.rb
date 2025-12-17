# プロフィール表示・編集を管理するコントローラ
class ProfilesController < ApplicationController
  # ログインユーザーのみアクセス可能
  before_action :authenticate_user!

  # プロフィール表示
  def show
    # current_userはDeviseが提供するヘルパーメソッド
    @user = current_user
  end

  # プロフィール編集フォーム
  def edit
    @user = current_user
  end

  # プロフィール更新処理
  def update
    @user = current_user

    # パスワード欄が空の場合は、パスワード以外の項目のみ更新
    if params[:user][:password].blank?
      # パスワード関連のパラメータを除外して更新
      if @user.update(profile_params_without_password)
        redirect_to profile_path, notice: "プロフィールを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # パスワードも含めて更新
      if @user.update(profile_params)
        # パスワード変更後は再ログインが必要なため、サインインし直す
        bypass_sign_in(@user)
        redirect_to profile_path, notice: "プロフィールを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  # パスワードを含む全パラメータ
  def profile_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # パスワードを除いたパラメータ
  def profile_params_without_password
    params.require(:user).permit(:username, :email)
  end
end
