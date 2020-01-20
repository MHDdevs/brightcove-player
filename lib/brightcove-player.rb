require 'brightcove_player/version'
require 'brightcove_player/rails_admin'
require 'active_record'

module BrightcovePlayer
  mattr_accessor :stat_model
  @@stat_model = 'lesson_stat'

  mattr_accessor :stat_method
  @@stat_method = :patch

  mattr_accessor :id
  @@id = nil

  mattr_accessor :table_name
  @@table_name = nil

  mattr_accessor :airbrake
  @@airbrake = {id: nil, key: nil}

  mattr_accessor :account_id
  @@account_id = nil

  mattr_accessor :player_id
  @@player_id = nil

  mattr_accessor :client_id
  @@client_id = nil

  mattr_accessor :client_secret
  @@client_secret = nil

  mattr_accessor :embed
  @@embed = 'default'

  mattr_accessor :bumpers
  @@bumpers = {
    default: nil
  }

  def self.table_name=(table_name)
    @@table_name = table_name
    BrightcovePlayer::Video.table_name = BrightcovePlayer.table_name unless @@table_name.nil?
  end

  def self.configure
    yield self
  end
end

require_relative '../app/models/brightcove_player/video.rb'
require 'brightcove_player/api'
require 'brightcove_player/player_helper'
require 'brightcove_player/pulse_tag_field'
require 'brightcove_player/engine'
require 'brightcove_player/player'
require 'brightcove_player/brightcoveable'
