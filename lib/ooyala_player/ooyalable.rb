module OoyalaPlayer
  module Ooyalable
    extend ActiveSupport::Concern

    def ooyalable(*options)
      # has_one :pulse_tag_relation, class_name: 'PulseTag',
      #                              primary_key: video_column,
      #                              foreign_key: :ooyala_id

      video_column = (options[0] || 'ooyala_video_id').to_sym
      method_name = options[0].present? ? "pulse_tags_for_#{options[0]}" : 'pulse_tags'

      define_method method_name.to_sym do
        OoyalaPlayer::Video.find_or_create_by(ooyala_id: self.send(video_column)).tags
      end

    end
  end
end

