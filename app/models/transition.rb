class Transition < ActiveRecord::Base
  attr_accessible :enter_state, :exit_state, :comment, :user_id
  belongs_to :user
  belongs_to :project
  
  validates_inclusion_of :enter_state, :in => Project.aasm_states.map{|s| s.name.to_s}, :allow_nil => true
  validates_inclusion_of :exit_state, :in => Project.aasm_states.map{|s| s.name.to_s}, :allow_nil => true
end
