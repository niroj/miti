# frozen_string_literal: true

require_relative "../../spec_helper"
require "action_controller"
require "rack/mock"
require "active_support/core_ext/date/calculations"
require "miti/rails/controller_concern"

RSpec.describe Miti::Rails::ControllerConcern do
  let(:controller_class) do
    Class.new(ActionController::Metal) do
      include AbstractController::Callbacks
      include ActionController::StrongParameters
      include Miti::Rails::ControllerConcern

      auto_convert_bs_dates :from, :to

      def index
        self.response_body = [params[:from].inspect, params[:to].inspect].join("|")
      end
    end
  end

  def call(query)
    env = Rack::MockRequest.env_for("/?#{query}")
    _status, _headers, body = controller_class.action(:index).call(env)
    body.each.to_a.join
  end

  describe ".auto_convert_bs_dates" do
    it "converts BS params to AD dates on any action" do
      expected = [Date.new(2025, 4, 28), Miti.to_ad("2082-02-01")].map(&:inspect).join("|")
      expect(call("from=2082-01-15&to=2082-02-01")).to eq(expected)
    end

    it "leaves blank and invalid params untouched" do
      expect(call("from=not-a-date")).to eq('"not-a-date"|nil')
    end
  end

  describe "#parse_date_param" do
    let(:controller) { controller_class.new }

    it "converts a BS string to an AD date" do
      expect(controller.parse_date_param("2082-01-15")).to eq(Date.new(2025, 4, 28))
    end

    it "falls back to today for blank or invalid input" do
      expect(controller.parse_date_param("")).to eq(Date.current)
      expect(controller.parse_date_param("garbage")).to eq(Date.current)
    end
  end
end
