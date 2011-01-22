class SessionsController < ApplicationController
  
  # Student login page.
  def new0
    if signed_in?
      redirect_to user_profile_path(remember_token[0])
    else  
      @title = 'Student Login'
    end
  end
  
  # Professor login page.
  def new1
    if signed_in?
      redirect_to user_profile_path(remember_token[0])
    else
      @title = 'Faculty Login'
    end
  end
  
  # Create new session cookie, when a student or professor logs in.
  def create
    # call authentication function for user; confirm that their email
    # and password are in the database
    user = User.authenticate(params[:session][:email], params[:session][:password])

    # if authentication fails, flash error message (for rendered pages) and re-r
    # ender signin page (either the student or the professor page).
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      if params[:usertype] == '0' 
        render 'new0'
      else
        render 'new1'
      end
    # Sign the user in and redirect to the user's homepage/profile
    else
      if user.verified == '1'
        sign_in user
        redirect_to user_profile_path(user.id.to_s)
      else
        if params[:usertype] == '0'
<<<<<<< HEAD
          redirect_to(signin0_path) 
=======
          @title = "Student Login"
          flash.now[:error] = "You have not been verified."
          render 'new0'
>>>>>>> c98bb5747744b977e52b4d4aa1f5fdec643efeae
        else
          @title = "Faculty Login"
          flash.now[:error] = "You have not been verified."
          redirect_to(signin1_path) 
        end
      end
    end
  end
  
  # Destroy current session cookie, to sign user out; our cookie is permanent,
  # in that it doesn't expire, even if he/she exits his browser,
  # until the user explicitly logs out. Redirect to root.
  def destroy
    sign_out
    redirect_to root_path
  end

end
