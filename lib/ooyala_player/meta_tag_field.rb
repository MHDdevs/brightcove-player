module OoyalaPlayer
  class MetaTagField < RailsAdmin::Config::Fields::Base
    register_instance_option :formatted_value do
      o = bindings[:object]
      v = bindings[:view]

      r = "<ul>"
      if o.meta.present?
        o.meta.map do |key, value|
          r +="<li><b>#{key}</b> #{value} </li>"
        end
      end
      r += "</ul>"
      r.html_safe()
    end
  end
end

RailsAdmin::Config::Fields::Types::register(:meta_tag_field, OoyalaPlayer::MetaTagField)
