require 'ooyala_player/version'
require 'ooyala_player/rails_admin'
require 'active_record'

  module OoyalaPlayer
    mattr_accessor :version
    @@version = 'latest'

    mattr_accessor :pulse_category
    @@pulse_category = nil

    mattr_accessor :pulse_host
    @@pulse_host = nil

    mattr_accessor :stat_model
    @@stat_model = 'lesson_stat'

    mattr_accessor :stat_method
    @@stat_method = :patch

    mattr_accessor :id
    @@id = nil

    mattr_accessor :ooyala_api_key
    @@ooyala_api_key = nil

    mattr_accessor :ooyala_secret_key
    @@ooyala_secret_key = nil

    mattr_accessor :forward_url
    @@forward_url = nil

    mattr_accessor :table_name
    @@table_name = nil

    mattr_accessor :airbrake
    @@airbrake = {id: nil, key: nil}

  def self.table_name=(table_name)
    @@table_name = table_name
    OoyalaPlayer::Video.table_name = OoyalaPlayer.table_name unless @@table_name.nil?
  end

  def self.configure
    yield self
  end
end

require_relative '../app/workers/ooyala_player/ooyala_tags_fetcher.rb'
require_relative '../app/models/ooyala_player/video.rb'
require 'ooyala_player/player_helper'
require 'ooyala_player/pulse_tag_field'
require 'ooyala_player/engine'
require 'ooyala_player/player'
require 'ooyala_player/ooyalable'
