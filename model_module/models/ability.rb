class Ability
  include CanCan::Ability

  #def initialize(user)
  # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  #end
  def initialize(user)
    can :read, ActiveAdmin::Page, :name => "Dashboard"
    user ||= SuperUser.new
    case user.role
      when "admin"
        can :manage, :all
      when "market"
        can :manage, MarketCount
        can :manage, PartnerMonthAccount
        can :manage, DistributeMobileCharge
        can :manage, Partmer
        can :manage, PartnerBaobiao
        can :manage, UserTotalConsumeList
        can :manage, PersonalGetMobileCharge
        can :manage, UserMobileList
        can :manage, DdzBaobiao
        can :manage, MatchSystemSetting
        can :manage, MatchArrangement
        can :manage, MatchBonusSetting
        can :manage, MatchDesc
        can :manage, SpecialMatchArrangement
        can :manage, SpecialMatchBonusSetting
        #can :manage, MlTest
        #can :manage, DdzSheet
        #can :manage, GameTeach
        can :manage, UserSheet
        can :manage, UserCreditSetup
        can :manage, UserScoreList
        can :manage, GameProductSellCount
        can :manage, EveryHourOnlineUser
        can :manage, UserMobileSource
        can :manage, UserChangeMobile
      when "cs"
        can :manage, MarketCount
        can :manage, PayMobile
        can :manage, KefuPayMobile
      when "pdc"
        can :manage, PartnerBaobiao
        can :manage, DdzBaobiao
      when "boss"
        can :manage, DistributeMobileCharge
        can :manage, MarketCount
        can :manage, PartnerBaobiao
        can :manage, UserTotalConsumeList
        can :manage, PersonalGetMobileCharge
        can :manage, UserMobileList
        can :manage, DdzBaobiao
        #can :manage, DdzSheet
        can :manage, GameView
        can :manage, GameProductSellCount


    end
  end
end
