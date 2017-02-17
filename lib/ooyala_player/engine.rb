module OoyalaPlayer
  class Engine < ::Rails::Engine
    ActionView::Base.send :include, PlayerHelper
  end
end
