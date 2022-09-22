# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :read, Booking

    if current_user&.is_client
      can :update, Booking, user_id: current_user.id
    end

    if current_user&.is_trainer
      can :update, Booking
    end

    if current_user&.is_super_user
      can :manage, :all
    end

  end
end
