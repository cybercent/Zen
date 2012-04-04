class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :invite_code
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :invite_code
  
  
  has_many :projects, :dependent => :destroy
  has_many :transitions
  
  validates :name, :presence => true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :invite_code, :inclusion => { :in => ['LECAMPING','GARDEN','lecamping','garden'], :message => "%{value} is not valid" }, :on => :create
  
  def is_admin?
    id == 1
  end
    
  def free_projects
    d = Settings.free_projects - projects.count
    d > 0 ? d : 0
  end

  def active_projects_value
    projects.sum(:exact_value, :conditions => {:aasm_state => [:lead, :pitch, :negotiation, :closing]})
    #projects.map(&:exact_value).compact.inject(0,:+)
  end
  
  def active_projects_count
    projects.count(:conditions => {:aasm_state => [:lead, :pitch, :negotiation, :closing]})
  end
  
  def all_time_projects_count
    projects.count
  end
  
  def active_projects_average_value
    active_projects_count == 0 ? 0 : active_projects_value / active_projects_count
  end
  
end
