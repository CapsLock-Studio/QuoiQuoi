class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    # admin abilities
    admin ||= Admin.new

    if admin.role == 'admin'
      #can :index, :home
      #can [:index, :new, :edit], Product
      can :manage, Admin
      can :manage, Locale
      can :manage, SlidePosition
    else admin.role == 'author'
      can :manage, Admin
      can :manage, ArticleType
      can :manage, Product
      can :manage, ProductCustomItem
      can :manage, ProductMaterialType
      can :manage, Course
      can :manage, Order
      can :manage, OrderCustomItem
      can :manage, Slide
      can :manage, Broadcast
      can :manage, Material
      can :manage, Payment
      can :manage, Gift
      can :manage, UserGift
      can :manage, Message
      can :manage, Registration
      can :manage, Designer
      can :manage, RentInfo
      can :manage, RentIntro
      can :manage, RentInfoImage
      can :manage, IntroduceImageSlide
      can :manage, IntroduceYoutube
      can :manage, Requirement
      can :manage, RequirementIntro
      can :manage, Article
      can :manage, ArticleImage
      can :manage, Remittance
      can :manage, ShippingFee
      can :manage, TravelInformation
      can :manage, TravelPhoto
      can :manage, OrderInformation
      can :manage, Instruction
      can :manage, InstructionImage
      can :manage, Area
      can :manage, Faq
      can :manage, ProductType
      can :manage, Top
    end

    # for development
    # can :manage, :all
  end
end