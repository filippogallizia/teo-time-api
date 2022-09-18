class BookingsController < ApplicationController
  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(params[:userId, :trainerId, :start, :end])
  end

  private

  def user_params
    params.require(:user).permit(:userId, :trainerId, :start, :end)
  end
end
