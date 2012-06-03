
module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end

  def current_user=(user)
    @current_user ||= user_from_remember_token
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def user_from_remember_token
      remember_token = cookies[:remember_token]
      User.find_by_remember_token(remember_token) unless remember_token.nil?
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def admin_user
    redirect_to root_path, notice: "You must be logged in as GPEN Administrator to view that page." unless signed_in? && (current_user.admin == true)
  end

  def org_admin
    redirect_to root_path, notice: "You must be logged in as an organization administrator to view that page." unless signed_in? && (current_user.admin or current_user.organizations.any?)
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

end
