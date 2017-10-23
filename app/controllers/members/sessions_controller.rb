class Members::SessionsController < Devise::SessionsController
  layout 'front'
  after_action :clear_flash, only:[:create, :destroy]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def signed_out
    @message = 'ログアウトしました'
    render '/message'
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    members_signed_out_path
  end

  def clear_flash
    if flash[:notice].present?
      flash.delete(:notice)
    end
  end
end
