class ApplicationController < ActionController::Base
  # Deviseのパラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にusernameを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
    # アカウント編集時にusernameを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end

  def after_sign_in_path_for(rescource)
    # サインイン後は参拝記録一覧ページへリダイレクト
    shrine_records_path
  end
end
