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
        cannot [:create, :destroy], Organisation
      end

      if user.manager?
        can :read, User, user: { department: user.department }
        can [:read, :update], Position, user: { department: user.department }
        cannot :manage, [User, Organization]
      end

      if user.employee?
        can [:read, :update], User, id: user.id
        can [:read, :update], Position, user_ids: user.id
      end

      if user.super_admin?
        can :manage, :all
      end
  end
end
