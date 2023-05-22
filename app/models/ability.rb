# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # define ability for simple user, admin, super_admin, manager, and cto.
    if user.persisted?
      if user.super_admin?
        can :manage, :all
      elsif user.admin?
        can [:read, :update], Organization, organization_id: user.organization_id
        can :manage, Department, organization_id: user.organization_id
        can :manage, Position, organization_id: user.organization_id
        can :manage, Salary, organization_id: user.organization_id
        can :manage, User, organization_id: user.organization_id, role: ['employee', 'admin', 'manager']
        can :manage, Assistance
      elsif user.employee?
        can :read, Position, organization_id: user.organization_id
        can [:read, :update], User, id: user.id
        can :read, Department, organization_id: user.organization_id
        can :read, Salary, user_id: user.id, organization_id: user.organization_id
        can :manage, Assistance, user_id: user.id
      elsif user.manager?
        can :manage, Department, organization_id: user.organization_id
        can :manage, Position, organization_id: user.organization_id
        can [:read, :update, :me, :destroy], User, id: user.id
        can :manage, Salary, organization_id: user.organization_id
        can :manage, Assistance
      else
        # Unauthorized user or unauthenticated request
        cannot :manage, :all
        cannot :read, :all
      end
    end
  end
end
