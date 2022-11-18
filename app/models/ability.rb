# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :read, Booking
    can :read, Event

    if current_user&.is_client
      can :update, Booking, user_id: current_user.id
    end

    if current_user&.is_trainer
      can :update, Booking, trainer_id: current_user.id
      can :update, Event, trainer_id: current_user.id

    end

    if current_user&.is_admin
      can :manage, :all
    end

  end
end
