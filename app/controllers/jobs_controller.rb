class JobsController < ApplicationController
  #make sure user is logged in
  before_filter :authenticate

  # lists all jobs
  def index
    @jobs = Job.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  # show a particular job listing. 
  def show
    @job = Job.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # create a new job listing, only if you are a professor.
  def new
    @job = Job.new
    if User.find(remember_token[0]).usertype != 1
      redirect_to(user_profile_path(remember_token[0]))
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @job }
      end
    end
  end

  # edit a job listing, but only if you are the user who created the listing
  def edit
    @job = Job.find(params[:id])
    if remember_token[0] != @job.user_id
      redirect_to(user_profile_path(remember_token[0]))
    end
  end

  # create a new job listing, but only if you are a professor
  def create
    @job = Job.new(params[:job])
    @job.user_id = remember_token[0]
    if User.find(remember_token[0]).usertype != 1
      redirect_to(user_profile_path(remember_token[0]))
    else
    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
end

  # update a job listing, but only if you created the original listing. 
  # edit calls update
  def update
    @job = Job.find(params[:id])
    if remember_token[0] != @job.user_id
      redirect_to(user_profile_path(remember_token[0]))
    end
    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # delete job listing, but only if you are the one who originally created it.
  def destroy
    @job = Job.find(params[:id])
    if remember_token[0] != @job.user_id
      redirect_to(user_profile_path(remember_token[0]))
    else
      @job.destroy

      respond_to do |format|
        format.html { redirect_to(jobs_url) }
        format.xml  { head :ok }
      end
    end
  end

  private
    #deny user access to page, unless logged in
    def authenticate
      deny_access unless signed_in?
    end
end
