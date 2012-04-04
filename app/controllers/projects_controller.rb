class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :through => :current_user
  
  def index
    @project = Project.new
    @projects = current_user.projects.where({:aasm_state => [:lead, :pitch, :negotiation, :closing, :hold]}).order('created_at DESC')
    @free_projects = current_user.free_projects
    @active_projects_value = current_user.active_projects_value
    @active_projects_count = current_user.active_projects_count
  end
  
  def create
    if current_user.projects.count < Settings.free_projects
    @project = current_user.projects.build(params[:project])
    if @project.valid?
      @project.save
      @transition = @project.transitions.build({:user_id => current_user.id, :enter_state => "lead"})
      if @transition.valid?
        @transition.save
      else
        render :nothing => true, :status => 500 and return if request.xhr?
        redirect_to projects_path and return
      end
      render :partial => 'project', :locals => { :project => @project, :projects_stats => true }, :layout => false and return if request.xhr? 
      redirect_to projects_path
    end
    else
      render :partial => 'limit_reached' and return if request.xhr?
      redirect_to projects_path, :notice => "You reached the free project limit."
    end
  end

  def update
    if @project.update_attributes(params[:project]) 
      render :partial => 'project', :locals => { :project => @project, :projects_stats => true }, :layout => false and return if request.xhr?
      redirect_to project_path(@project)
    end
  end
  
  def show
    @completed_transitions = @project.transitions.where("exit_state IS NOT NULL").order("created_at DESC")
    @new_transition = Transition.new
  end
  
  def destroy
    @project.destroy
    render :partial => 'project', :locals => { :project => @project, :projects_stats => true }, :layout => false and return if request.xhr?
    redirect_to projects_path
  end
  
  def completed
    @projects = current_user.projects.where({:aasm_state => [:lost, :won]}).order("created_at DESC")
  end
  
end
