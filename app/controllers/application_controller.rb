class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  # before_action and after_action below are needed because of bug in devise-token-auth dealing with ng-token-auth
  # (not completely signing out, what causes old session restoring
  # when sign out from email provider and sing in with facebook provider or vice versa)
  before_action do
    if params[:provider] == 'facebook'
      reset_session
      params[:provider] = 'facebook'
    end
  end

  after_action do
    if cookies[:auth_headers] == '{}' && cookies[:currentConfigName].blank?
      reset_session
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: 404
  end

  protected

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end
