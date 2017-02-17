require "player/version"
require 'player_helper'

module Player
  p '--------------------------------------------------------------------------'
  p "Player #{Time.now}"
  class Engine < ::Rails::Engine
  end


  mattr_accessor :version
  @@version = 'latest'

  mattr_accessor :id
  @@id = nil

  mattr_accessor :ooyala_api_key
  @@ooyala_api_key = nil

  mattr_accessor :ooyala_secret_key
  @@ooyala_secret_key = nil

  def self.configure
    yield self
  end

end

ActionView::Base.send :include, PlayerHelper
