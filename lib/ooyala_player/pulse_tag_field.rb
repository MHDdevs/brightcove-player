module OoyalaPlayer
  class PulseTagField < RailsAdmin::Config::Fields::Base

    register_instance_option :formatted_value do
      o = bindings[:object]
      v = bindings[:view]
      I18n.available_locales.map do |locale|
        o.class.video_columns.map do |column|
          video = o.send(column == :ooyala_video_id ? "video" : "video_for_#{column}", locale)
          if video.present?
            tags = video.tags
            tags = 'no_tags' if tags.blank?
            "Tags for #{column}[#{locale}] #{v.link_to tags, v.show_path(model_name: 'OoyalaPlayer~Video', id: video.id)}"
          else
            'no_tags'
          end
        end.join('<br/>')
      end.join('<br/>').html_safe()

    end

    register_instance_option :partial do
      :pulse_tags
    end

  end
end

RailsAdmin::Config::Fields::Types::register(:pulse_tags_field, OoyalaPlayer::PulseTagField)
