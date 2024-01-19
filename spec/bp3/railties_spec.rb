# frozen_string_literal: true

require 'action_controller'
require 'rails/mailers_controller'

RSpec.describe Bp3::Railties do
  it 'has a version number' do
    expect(Bp3::Railties::VERSION).not_to be_nil
  end

  # it 'does something useful' do
  #   expect(Rails::MailersController.ancestors).to include(Bp3::Railties::Actions)
  #   expect(Rails::MailersController.ancestors).to include(Bp3::Railties::Settings)
  #   expect(Rails::MailersController.ancestors).to include(Bp3::Railties::FeatureFlags)
  #   expect(Rails::MailersController.ancestors).to include(Bp3::Railties::Cookies)
  # end
end
