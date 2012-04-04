class Project < ActiveRecord::Base
  attr_accessible :name, :client, :exact_value, :estimate_value, :state
  belongs_to :user
  has_many :transitions, :dependent => :delete_all
  
  include AASM
  aasm_initial_state :lead
  aasm_state :lead
  aasm_state :pitch
  aasm_state :negotiation
  aasm_state :closing
  aasm_state :won
  aasm_state :lost
  aasm_state :hold
  
  aasm_event :enter_lead do
    transitions :to => :lead, :from => [:pitch, :negotiation, :closing, :hold]
  end
  
  aasm_event :enter_pitch do
    transitions :to => :pitch, :from => [:lead, :negotiation, :closing, :hold]
  end
  
  aasm_event :enter_negotiation do
    transitions :to => :negotiation, :from => [:lead, :pitch, :closing, :hold]
  end
  
  aasm_event :enter_closing do
    transitions :to => :closing, :from => [:lead, :pitch, :negotiation, :hold, :won, :lost]
  end
  
  aasm_event :enter_won do
    transitions :to => :won, :from => [:lead, :pitch, :negotiation, :closing]
  end
  
  aasm_event :enter_lost do
    transitions :to => :lost, :from => [:lead, :pitch, :negotiation, :closing]
  end
  
  aasm_event :enter_hold do
    transitions :to => :hold, :from => [:lead, :pitch, :negotiation, :closing]
  end
  
  def value
    exact_value || ('$' * (estimate_value || 0))
  end
  
  def self.ordered_states
    [:lead, :pitch, :negotiation, :closing, :won]
  end
  
end
