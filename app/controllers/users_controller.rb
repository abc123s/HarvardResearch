class UsersController < ApplicationController
  # Note: Students have usertype = 0 and Professors have usertype = 1
  # Make sure user is logged in
  before_filter :authenticate, :only => [:index, :show, :edit, :update, :destroy, :profile]
  before_filter :correct_user, :only => [:update, :destroy, :edit]

  helper_method :sort_column, :sort_direction	
  
  # show all users
  def index
    if User.find(remember_token[0]).usertype == 0
      @title = 'Faculty'
      if params[:department].present?
        @users = User.with_department(params[:department]).searchinterests(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
      else
        @users = User.with_type(1).searchinterests(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
      end
    elsif User.find(remember_token[0]).usertype == 1
      @title = 'Students'
      if params[:concentration].present?
        @users = User.with_concentration(params[:concentration]).searchresume(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
      else
	@users = User.with_type(0).searchresume(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
      end
    else
      @users = User.all.searchresume(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
      @title = 'All Users'
    end
    
    @departments = Set.new
    User.all.each { |user|
      if user.department?
        @departments.add(user.department)
      end
      }
    @departments.to_a.sort

    @concentrations = Set.new
    User.all.each { |user|
      if user.concentration?
        @concentrations.add(user.concentration)
      end
      }
    @concentrations.to_a.sort

    # render pages	
    respond_to do |format|
      format.html
      format.xml  { render :xml => @users }
    end 
  end

  # show a specific user
  def show
  if params[:id] == remember_token[0]
    redirect_to(user_profile_path(remember_token[0]))
  else  
    @user = User.find(params[:id])
    @title = @user.firstname
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  end

  # create a new student
  def new0
    @user = User.new
    @user.verified = 0
    @user.usertype = 0
    @title = "Sign Up"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # create a new professor
  def new1
    @user = User.new
    @user.usertype = 1
    @user.verified = 0
    @title = "Sign Up"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end


  # edit profile
  def edit
    if current_user?(@user)
      @title = "Edit Profile"
    else
      redirect_to(edit_user_path(remember_token[0]))
    end
  end

  # create new user dependent on status as student or professor
  def create
    @user = User.new(params[:user])
    @user.code = 100000000000000+ rand(899999999999999)
    @user.verified = 0
    respond_to do |format|
      if @user.save
        Notifications.signup(@user).deliver
        if @user.usertype == 0
          format.html { redirect_to(signin0_path, :notice => "Mail sent.  Check your email to confirm your registration.")}
        else @user.usertype == 1
          format.html { redirect_to(signin1_path, :notice => "Mail sent.  Check your email to confirm your registration.")}
        end
      else 
        @title = "Sign Up"
        if @user.usertype == 0
          format.html { render :action => "new0" }
        else
          format.html { render :action => "new1" }
        end
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # welcome user to new profile
  def welcome
    @user = User.find(params[:id])
    respond_to do |format|
        if @user.code.to_s == params[:code] 
          @user.verified = 1
          @user.save!
          sign_in @user
          flash[:success] = "Welcome to Harvard Research!"
          format.html { redirect_to(user_profile_path(@user.id.to_s), :notice => 'User was successfully created.' ) }
          format.xml { render :xml => @user, :status => :created, :location => @student }
        else
          if @user.usertype == 0
            format.html { redirect_to(signin0_path, :notice => 'Registration failed.  Please wait 24 h to re-register.')}
          else
            format.html { redirect_to(signin1_path, :notice => 'Registration failed.  Please wait 24 h to re-register.')}
          end
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
    end
  end
  
  def changepassword
    if params[:id] == remember_token[0].to_s
      @title = "Change Password"
      @user = User.find(params[:id])
    else
      redirect_to(changepassword_user_path(remember_token[0]))
    end  
  end
  
  # help edit profile
  def update
    @user = User.find(params[:id])
    respond_to do |format|
    if @user.has_password?(params[:user][:old_password]) 
      if @user.update_attributes(params[:user])
        format.html { redirect_to(user_profile_path(params[:id]), :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    else
      format.html { redirect_to(edit_user_path(params[:id]), :notice => 'Incorrect Password. Update failed.') }
    end
  end
end

  # delete a user
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  #user profile page
  def profile
    @user = User.find(params[:id])
    @title = @user.firstname
    if @user.id == remember_token[0]  
      if @user.usertype == 1
        @jobs = @user.jobs
        respond_to do |format|
          format.html # profile.html.erb
          format.xml  { render :xml => @jobs }
        end
      else
        @submissions = @user.submissions
        respond_to do |format|
          format.html # profile.html.erb
          format.xml { render :xml => @submissions }
        end
      end
    else
      redirect_to(user_profile_path(remember_token[0]))
    end
  end

  private
    #deny user access to page, unless logged in
    def authenticate
      deny_access unless signed_in?
    end

    #deny user access to page, unless he has permissions
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    #sorting
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "lastname"
    end
    
    def sort_direction
      %W[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
