class MetricsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @won = current_user.projects.count(:conditions => {:aasm_state => 'won'})
    @lost = current_user.projects.count(:conditions => {:aasm_state => 'lost'})
    
    @value_per_state = current_user.projects.sum(:exact_value, :group => :aasm_state)
    @time_per_state = current_user.transitions.sum("updated_at - created_at", :group => :enter_state)
  end
  
end
