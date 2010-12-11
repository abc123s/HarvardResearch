module SessionsHelper

  # Sign-in function places a "remember token" session cookie on the browser
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end

  # Method for assignment to current_user; calls user_from_remember_token only first time, else just @current_user
  def current_user
      @current_user ||= user_from_remember_token
  end

  # Helper method to determine if user is signed in
  def signed_in?
    !current_user.nil?
  end

  # Sign-out function deletes the remember_token and sets current_user to nil
  def sign_out
      cookies.delete(:remember_token)
      current_user = nil
  end
 
  #checks if the current user matches the given user
  def current_user?(user)
    user == current_user
  end

  #redirects user to homepage
  def deny_access
    redirect_to "/", :notice => "Please sign in to access this page."
  end

  private
    # Authenticate user with remember_token, returns the user if authentication passes via authenticate_with_salt
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    # Helper method to ensure [nil, nil] is returned if it is nil
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
