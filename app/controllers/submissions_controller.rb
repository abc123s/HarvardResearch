class SubmissionsController < ApplicationController
  before_filter :authenticate

  #list all submissions 
  def index
    redirect_to(user_profile_path(remember_token[0]))
=begin
    @submissions = Submission.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @submissions }
    end
=end
  end
  # shows a specific submission
  def show
    @submission = Submission.find(params[:id])
    @title = 'Application'
    if (remember_token[0] != @submission.user_id) && (User.find(remember_token[0]).usertype != 1) 
      redirect_to(user_profile_path(remember_token[0]))
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @submission }
    end  
  end
  end

  # makes new submission
  def new 
    @title = 'Apply'
    @submission = Submission.new
    @submission.job_id = params[:jobid]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @submission }
    end
  end

  # edit submissions
  def edit
    @submission = Submission.find(params[:id])
    if remember_token[0] != @submission.user_id
      redirect_to(user_profile_path(remember_token[0]))
    end
  end

  # create a new submission
  def create
    @submission = Submission.new(params[:submission])
    @submission.user_id = remember_token[0]
    respond_to do |format|
      if @submission.save
        format.html { redirect_to(@submission, :notice => 'Submission was successfully created.') }
        format.xml  { render :xml => @submission, :status => :created, :location => @submission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # update a submission (via edit)
  def update
    @title = 'Edit Application'
    @submission = Submission.find(params[:id])
    if remember_token[0] != @submission.user_id
      redirect_to(user_profile_path(remember_token[0]))
    end
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to(@submission, :notice => 'Submission was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # delete a submission
  def destroy
    @title = 'Delete Application'
    @submission = Submission.find(params[:id])
    if remember_token[0] != @submission.user_id
      redirect_to(user_profile_path(remember_token[0]))
    else
      @submission.destroy

      respond_to do |format|
        format.html { redirect_to(user_profile_path(remember_token[0])) }
        format.xml  { head :ok }
      end
    end
  end

  private
    # deny user access to page, unless signed in
    def authenticate
      deny_access unless signed_in?
    end
end
