module BrightcovePlayer
  class AssetField < RailsAdmin::Config::Fields::Base
    register_instance_option :formatted_value do
      o = bindings[:object]
      v = bindings[:view]

      JSON.pretty_generate(o.assets) if o.assets.present?
    end
  end
end

RailsAdmin::Config::Fields::Types::register(:asset_field, BrightcovePlayer::AssetField)
