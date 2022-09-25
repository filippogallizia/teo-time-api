class TestController < ApplicationController
  def yo
    render :json => { user: current_user, trainer: current_trainer }
  end
end