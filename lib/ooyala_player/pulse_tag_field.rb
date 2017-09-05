module OoyalaPlayer
  class PulseTagField < RailsAdmin::Config::Fields::Base

    register_instance_option :formatted_value do
      o = bindings[:object]
      v = bindings[:view]
      tags = I18n.available_locales.map do |locale|
        o.class.video_columns.map do |column|
          video = o.try(column == :ooyala_video_id ? "video" : "video_for_#{column}", locale)
          if video.present?
            tags = video.tags
            tags = 'no_tags' if tags.blank?
            "Tags for #{column}[#{locale}] " +
            if v.present?
                "#{v.link_to tags, v.show_path(model_name: 'OoyalaPlayer~Video', id: video.id)}"
            else
              tags
            end
          end
        end.compact.join('<br/>')
      end.reject(&:empty?).join('<br/>').html_safe()
      tags.gsub! '<br/>', "\n" if v.nil?
      tags
    end

    register_instance_option :partial do
      :pulse_tags
    end

  end
end

RailsAdmin::Config::Fields::Types::register(:pulse_tags_field, OoyalaPlayer::PulseTagField)
