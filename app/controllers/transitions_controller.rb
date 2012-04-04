class TransitionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :disable_timestamps, :only => "update"
  after_filter :enable_timestamps, :only => "update"
  load_and_authorize_resource :project
  load_and_authorize_resource :transition, :through => :project
  
  def create
    @transition.user_id = current_user.id
    
    # Won, Lost and Hold
    @transition.enter_state = 'closing' if @transition.enter_state == 'reactivate'
    
    # Sent only a comment    
    @transition.enter_state = @project.aasm_state unless @transition.enter_state
    
    if @transition.valid?
      @last_transition = @project.transitions.order("id DESC").first
      if can? :update, @last_transition
        @last_transition.update_attributes({:exit_state => @transition.enter_state, :comment => @transition.comment})
      end
      @transition.comment = nil
      @transition.save
      @project.send(:"enter_#{@transition.enter_state}!") if @project.send(:"may_enter_#{@transition.enter_state}?")
      
      # Used for message posting
      # @new_transition = Transition.new
      
      render :partial => 'projects/project', :locals => { :project => @project, :transition => @last_transition, :projects_stats => true }, :layout => false and return if request.xhr?
      redirect_to project_path(@project)
    else
      render :nothing => true, :status => 500
    end
  end
  
  def update
    if can? :update, @transition
      @transition.update_attribute(:comment, params[:transition][:comment])
      render :nothing => true, :status => 200 and return if request.xhr?
    else
      render :nothing => true, :status => 500 and return if request.xhr?
    end
    redirect_to project_path(@project)
  end
  
  private 
  
  def disable_timestamps
    Transition.record_timestamps = false
  end
  
  def enable_timestamps
    Transition.record_timestamps = true
  end
  
end
