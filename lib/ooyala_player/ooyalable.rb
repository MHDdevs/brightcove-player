module OoyalaPlayer
  module Ooyalable
    extend ActiveSupport::Concern

    def ooyalable(*options)
      # has_one :pulse_tag_relation, class_name: 'PulseTag',
      #                              primary_key: video_column,
      #                              foreign_key: :ooyala_id

      video_column = (options[0] || 'ooyala_video_id').to_sym
      method_name = options[0].present? ? "video_for_#{options[0]}" : 'video'

      define_method method_name.to_sym do |locale=nil|
        col = video_column
        col = "#{col}_#{locale}".to_sym if locale.present?
        column_method = self.send(col)
        OoyalaPlayer::Video.find_or_create_by(ooyala_id: column_method) unless column_method.nil?
      end

      # For rails admin method corresponding to column
      define_method :pulse_tags do
      end

      I18n.available_locales.each do |locale|
        define_method "#{method_name}_#{locale}" do
          self.send(method_name, locale)
        end
      end

      if self < ActiveRecord::Base
        # OoyalaPlayer::Video.add_with_videos name: self.name, column: video_column
        if Globalize::Accessors::InstanceMethods.in? self.ancestors
          OoyalaPlayer::Video.add_with_videos name: "#{self.name}::Translation", column: video_column
        end
      else
        OoyalaPlayer::Video.add_with_videos name: 'Setting', column: 'value'
      end

      # list of video columns
      metaclass = (class << self; self; end)
      metaclass.send(:attr_accessor, :video_columns)
      if self.video_columns.nil?
        self.video_columns = [video_column]
      else
        self.video_columns << video_column
      end
      # byebug
    end
  end
end

