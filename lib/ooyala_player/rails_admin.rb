require 'ooyala_player/pulse_tag_field'
require 'ooyala_player/meta_tag_field'
require 'ooyala_player/asset_field'
require 'ooyala_player/load_tag'
require 'ooyala_player/load_tags'


RailsAdmin.config do |config|
  config.included_models << 'OoyalaPlayer::Video'
  config.actions do
    load_tag do
      only 'OoyalaPlayer::Video'
    end

    load_tags do
      only %w(Collection Lesson)
    end

  end
  config.model 'OoyalaPlayer::Video' do

    label 'Ooyala Video'

    list do
      field :ooyala_id
      field :tags
      field :meta, :meta_tag_field
      field :assets, :asset_field
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
      field :tags
      field :meta, :meta_tag_field
      field :assets, :asset_field
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
      field :tags
      field :meta
      field :assets
    end

  end
end
