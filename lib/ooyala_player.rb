require 'ooyala_player/version'
require 'ooyala_player/rails_admin'
require 'active_record'
require_relative '../app/models/ooyala_player/video.rb'

  module OoyalaPlayer
    mattr_accessor :version
    @@version = 'latest'

    mattr_accessor :id
    @@id = nil

    mattr_accessor :ooyala_api_key
    @@ooyala_api_key = nil

    mattr_accessor :ooyala_secret_key
    @@ooyala_secret_key = nil

    mattr_accessor :forward_url
    @@forward_url = nil

  def self.configure
    yield self
  end
end

require 'ooyala_player/player_helper'
require 'ooyala_player/pulse_tag_field'
require 'ooyala_player/engine'
require 'ooyala_player/player'
require 'ooyala_player/ooyalable'
