# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      puts "is user super_admin? #{user.admin?}"
      organization_id = user.organization_id
      if user.super_admin?
        puts"super_admin"
        can :manage, :all
      elsif user.admin?
        can [:read, :update], Organization, id: organization_id
        can :manage, Department, organization_id: organization_id
        can :manage, Position, organization_id: organization_id
        can :manage, Salary, organization_id: organization_id
        can :manage, User, organization_id: organization_id, role: ['employee', 'admin', 'manager']
        can :manage, [WorkDay, Activity, Assistance], user_id: User.where(organization_id: organization_id)
      elsif user.employee?
        can :read, Position, organization_id: organization_id
        can [:read, :update, :profile], User, id: user.id
        can :reset_password, User, id: user.id
        can :read, Department, organization_id: organization_id
        can :read, Salary, user_id: user.id, organization_id: organization_id
        can :manage, Assistance, user_id: user.id, organization_id: organization_id
        can :read, WorkDay, user_id: user.id, organization_id: organization_id
        can :read, Activity, user_id: user.id, organization_id: organization_id
        cannot :update_role, User, organization_id: organization_id
      elsif user.manager?
        can :manage, Department, organization_id: organization_id
        can :manage, Position, organization_id: organization_id
        can [:read, :update, :me, :destroy, :profile], User, id: user.id, organization_id: organization_id
        can :manage, Salary, organization_id: organization_id
        can :manage, Assistance, user_id: User.where(organization_id: organization_id)
        can :manage, [WorkDay, Activity], user_id: User.where(organization_id: organization_id)
        cannot :update_role, User
      end
    else
      can :create, DemoRequest
    end
  end
end
