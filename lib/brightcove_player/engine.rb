module BrightcovePlayer
  class Engine < ::Rails::Engine
    require 'ruby-duration'
    require 'rails_admin'
    ActionView::Base.send :include, PlayerHelper
  end
end
