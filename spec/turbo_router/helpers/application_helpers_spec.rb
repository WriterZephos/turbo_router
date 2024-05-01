# frozen_string_literal: true

require "spec_helper"

RSpec.describe ::TurboRouter::ApplicationHelpers do
  describe "turbo_router_frame_id_for_request" do
    context "in controller" do
      it "responds_to? is true" do
        expect(::ApplicationController.new.respond_to?(:turbo_router_frame_id_for_request)).to eq(true)
      end
    end

    context "in application helpers" do
      it "responds_to? is true" do
        expect(::ActionView::Base.instance_methods.include?(:turbo_router_frame_id_for_request)).to eq(true)
      end
    end
  end
end
