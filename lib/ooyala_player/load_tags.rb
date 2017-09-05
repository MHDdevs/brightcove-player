require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class LoadTags < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :link_icon do
          'icon-tags'
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            object = Object.const_get params[:model_name].classify
            ids = object.video_columns.map do |field|
              if object&.translates?
                object.all.map { |m| m.translations.map { |p| p.try(field) } }.flatten
              else
                object.all.map { |m| m.try(field) }
              end.compact.uniq
            end.flatten.uniq
            OoyalaPlayer::OoyalaTagsFetcher.perform_async(ids)
            flash[:success] = t('admin.actions.load_tags.done')
            redirect_to index_path
          end
        end
      end
    end
  end
end
