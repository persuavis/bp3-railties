# frozen_string_literal: true

require 'rails/railtie'

module Bp3
  module Railties
    class Railtie < Rails::Railtie
      initializer 'bp3.railties.railtie.register' do |app|
        app.config.after_initialize do
          # Prepender ensures that common filters are invoked
          ::Rails::MailersController # preload
          module ::Rails
            class MailersController
              prepend Prepender
            end
          end
        end
      end
    end
  end
end
