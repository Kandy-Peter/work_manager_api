# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # define ability for simple user, admin, super_admin, manager, and cto.
    if user.persisted?
      can :update, User, id: user.id
      can :read, User, id: user.id

      if user.admin?
        can :manage, :all
        # except create new admin and orgranisation
        cannot :create, User, role: 'admin'
        cannot :create, Organisation
      end

      if user.manager?
        can :manage, User, country: user.country
      end

      if user.employee?
        can :read, User, country: user.country
      end

      if user.super_admin?
        # this is for super admin only, super is the one to set admin role
        # can create new admin, manager, employee, and create orgranisation
        can :manage, :all
        can :create, User
        can :create, Organisation

        # can manage all users, organisations, and all countries
        can :manage, User
        can :manage, Organisation
      end
  end
end
