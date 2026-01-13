# frozen_string_literal: true

require 'active_support'
require 'rails/railtie'

module Bp3
  module Railties
    class Railtie < Rails::Railtie
      initializer 'bp3.railties.railtie.register' do |app|
        app.config.after_initialize do
          ::Rails::MailersController # preload
          module ::Rails
            class MailersController
              include Bp3::Core::Actions
              include Bp3::Core::Settings
              include Bp3::Core::FeatureFlags
              include Bp3::Core::Cookies

              before_action :authenticate_root!
            end
          end
        end
      end
    end
  end
end
