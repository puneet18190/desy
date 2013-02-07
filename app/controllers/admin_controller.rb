class AdminController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :initialize_location, :initialize_players_counter
  
end
