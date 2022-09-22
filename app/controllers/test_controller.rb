class TestController < ApplicationController
  def yo
    p current_user, 'cuurrrent suer'
    p current_trainer, 'current_traienr'
    binding.pry
    render :json => { user: current_user, trainer: current_trainer }
  end
end