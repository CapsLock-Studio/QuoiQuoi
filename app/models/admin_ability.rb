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
      can :manage, Admin::SlidePosition
    else admin.role == 'author'
      can :manage, Admin
      can :manage, Admin::ArticleType
      can :manage, Admin::Product
      can :manage, Admin::ProductCustomItem
      can :manage, Admin::Course
      can :manage, Admin::Order
      can :manage, Admin::OrderCustomItem
      can :manage, Admin::Slide
      can :manage, Admin::Broadcast
      can :manage, Admin::Material
      can :manage, Admin::Payment
      can :manage, Admin::Gift
      can :manage, Admin::UserGift
      can :manage, Admin::Message
      can :manage, Admin::Registration
      can :manage, Admin::Designer
      can :manage, Admin::RentInfo
      can :manage, Admin::RentIntro
      can :manage, Admin::RentInfoImage
      can :manage, Admin::IntroduceImageSlide
      can :manage, Admin::IntroduceYoutube
      can :manage, Admin::Requirement
      can :manage, Admin::RequirementIntro
      can :manage, Admin::Article
      can :manage, Admin::ArticleImage
      can :manage, Admin::Remittance
      can :manage, Admin::ShippingFee
      can :manage, Admin::TravelInformation
      can :manage, Admin::TravelPhoto
      can :manage, Admin::OrderInformation
      can :manage, Admin::Instruction
      can :manage, Admin::InstructionImage
      can :manage, Admin::Area
      can :manage, Admin::Faq
      can :manage, Admin::ProductType
      can :manage, Admin::Top
    end

    # for development
    # can :manage, :all
  end
end