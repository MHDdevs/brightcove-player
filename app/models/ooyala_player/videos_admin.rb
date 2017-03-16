module OoyalaPlayer
  module VideosAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do

        list do
          field :ooyala_id
          field :tags
          field :parents do
            formatted_value do
              bindings[:object].parents.map do |p|
                bindings[:view].link_to [p.class.name, p.name].join('_'),  bindings[:view].show_path(model_name: p.class.name, id: p.id)
              end.join(', ').html_safe()
            end
          end
        end

        edit do
          field :ooyala_id
          field :tags
        end
      end
    end
  end
end
