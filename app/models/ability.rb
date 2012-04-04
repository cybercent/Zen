class Ability
  include CanCan::Ability

  def initialize(user)
    # User abilities
    can :manage, :all if user.is_admin?
    
    can :manage, User do |u|
      u == user
    end
    can :manage, Project do |p|
      p.user == user
    end
    can :manage, Transition do |t|
      t.project.user == user
    end
  end
end