require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class LoadTag < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
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
            message = []
            r = @object.update_tags!
            if r
              message << t('admin.actions.load_tag.done')
            else
              message << r
            end
            r = @object.update_assets!
            if r
              message << t('admin.actions.load_assets.done')
            else
              message << r
            end
            r = @object.update_meta!
            if r
              message << t('admin.actions.load_meta.done')
            else
              message << r
            end

            flash[:warning] = message.join('\n').html_safe()
            redirect_to show_path(model_name: 'OoyalaPlayer~Video', id: @object.id)
          end
        end
      end
    end
  end
end
