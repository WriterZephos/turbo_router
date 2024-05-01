# frozen_string_literal: true

require "active_support"

module TurboRouter
  module Controller
    extend ActiveSupport::Concern

    included do
      layout lambda {
        use_dynamic_layout? ? "layouts/turbo_router_content" : self.class.page_layout
      }

      before_action :set_turbo_frame_request_variant
    end

    class_methods do
      def page_layout(layout = nil)
        @page_layout ||= "application"
        @page_layout = layout if layout.present?
        @page_layout
      end

      def use_dynamic_layout(*actions)
        @dynamic_layout_actions = actions if actions.present?
      end

      def dynamic_layout_actions
        @dynamic_layout_actions ||= []
        @dynamic_layout_actions
      end
    end

    def use_dynamic_layout?
      turbo_frame_request? && self.class.dynamic_layout_actions&.include?(params[:action].to_sym)
    end

    def turbo_router_stream(template, id = :turbo_router_content, **options)
      render turbo_stream: turbo_stream.replace(id, template: template, locals: options)
    end

    private

    def set_turbo_frame_request_variant
      request.variant = if turbo_frame_request?
                          :turbo_frame
                        else
                          :page
                        end
    end
  end
end
