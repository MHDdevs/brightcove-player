require 'ooyala_player/version'
require 'ooyala_player/player_helper'
require 'ooyala_player/engine'
require 'ooyala_player/player'

module OoyalaPlayer
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
