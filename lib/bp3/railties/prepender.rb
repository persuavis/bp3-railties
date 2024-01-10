# frozen_string_literal: true

require 'rails/railtie'

module Bp3
  module Railties
    module Prepender
      extend ActiveSupport::Concern

      prepended do
        include Bp3::Core::Actions # TODO: figure this one out
        include Bp3::Core::Settings
        include Bp3::Core::FeatureFlags
      end

      def do_not_track
        false
      end
    end
  end
end
