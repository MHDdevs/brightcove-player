require 'brightcove_player/pulse_tag_field'
require 'brightcove_player/meta_tag_field'
require 'brightcove_player/asset_field'


RailsAdmin.config do |config|
  config.included_models << 'BrightcovePlayer::Video'

  config.model 'BrightcovePlayer::Video' do
    label 'Brightcove Video'

    list do
      field :ooyala_id
      field :brightcove_id
      field :parents do
        formatted_value do
          bindings[:object].parents.map do |p|
            name = p.try(:name) || p.try(:title) || p.try(:slug) || p.class.name
            bindings[:view].link_to [p.class.name, name].join('_'),  bindings[:view].show_path(model_name: p.class.name, id: p.id)
          end.join(', ').html_safe()
        end
      end
    end

    show do
      field :ooyala_id
      field :brightcove_id
      field :parents do
        formatted_value do
          bindings[:object].parents.map do |p|
            name = p.try(:name) || p.try(:title) || p.try(:slug) || p.class.name
            bindings[:view].link_to [p.class.name, name].join('_'),  bindings[:view].show_path(model_name: p.class.name, id: p.id)
          end.join(', ').html_safe()
        end
      end
    end

    edit do
      field :ooyala_id
      field :brightcove_id
    end

  end
end
