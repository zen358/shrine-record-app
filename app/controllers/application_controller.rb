class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Deviseのパラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にusernameを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
    # アカウント編集時にusernameを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end
end
