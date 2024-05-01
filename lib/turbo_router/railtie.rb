# frozen_string_literal: true
require "pry"

module TurboRouter
  class Railtie < Rails::Railtie
    initializer "turbo_router.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include TurboRouter::ViewHelpers
        include TurboRouter::ApplicationHelpers
      end
    end

    initializer 'turbo_router.controller_helpers' do
      ActiveSupport.on_load(:action_controller) { include TurboRouter::ApplicationHelpers }
    end
  end
end
