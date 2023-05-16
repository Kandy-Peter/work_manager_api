# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # define ability for simple user, admin, super_admin, manager, and cto.
    if user.persisted?
      if user.super_admin?
        can :manage, :all
      elsif user.admin?
        can :manage, Organization, id: user.organization_id
        can :manage, Department, organization_id: user.organization_id
        can :manage, Position, organization_id: user.organization_id
        can [:update_role], User, organization_id: user.organization_id, role: ['employee', 'admin', 'manager']
      elsif user.employee?
        can :read, Position, organization_id: user.organization_id
        can [:read, :update], User, id: user.id
      elsif user.manager?
        can :manage, Department, organization_id: user.organization_id
        can :manage, Position, organization_id: user.organization_id
        can [:read, :update, :me], User, id: user.id
      end
    end
  end
end
