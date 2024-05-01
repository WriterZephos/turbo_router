module TurboRouter
  module ApplicationHelpers
    def turbo_router_frame_id_for_request
      request.headers["Turbo-frame"].present? ? request.headers["Turbo-frame"] : "turbo_router_content"
    end
  end
end