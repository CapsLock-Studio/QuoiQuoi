class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    # admin abilities
    admin ||= Admin.new

    if admin.role == 'admin'
      #can :index, :home
      #can [:index, :new, :edit], Admin::Product
      can :manage, Admin
      can :manage, Admin::Locale
      can :manage, Admin::ProductCustomType
      can :manage, Admin::ProductType
    else admin.role == 'author'
      can :manage, Admin::Product
      can :manage, Admin::Course
      can :manage, Admin::Order
    end

    # for development
    can :manage, :all
  end
end