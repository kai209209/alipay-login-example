class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

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

  def sign_from_alipay
    notify_params = params.except(*request.path_parameters.keys)
    #这里需要增加对返回的参数notify_params的验证,以辨别是否是真正阿里返回的参数(暂时未加)
    @user = User.from_alipay(params)
    sign_in(:user, @user)
    redirect_to user_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
