# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bp3-railties adapts Rails' `railties` for BP3 (persuavis/black_phoebe_3), a multi-site multi-tenant Rails
application. It puts the mailer previews (`Rails::MailersController`, `/rails/mailers`) behind BP3's
request handling and limits them to roots.

## Commands

The gems run on Ruby 3.4.6 (`.ruby-version`). Prefix commands with `~/.rvm/bin/rvm 3.4.6 do` when the
shell is not already on it; a missing `rspec` means the wrong Ruby, not a missing bundle.

- `bundle exec rake` - specs and RuboCop (the default task)
- `bundle exec rspec spec/path/to/file_spec.rb[:LINE]` - one file or example
- `bundle exec rubocop` / `bundle exec rubocop -a`
- `bin/setup`, `bin/console`, `rake install`

## Architecture

`lib/bp3/railties/railtie.rb` reopens `Rails::MailersController` in an `after_initialize` block and:

- includes `Bp3::Core::Actions`, `Settings`, `FeatureFlags` and `Cookies` (gem bp3-core), which set the
  site, workspace, tenant, request id and visitor for each preview request, as for any other controller
- adds `before_action :authenticate_root!`, which comes from the application's Devise setup

There is nothing to configure: adding the gem is enough.

```
lib/
  bp3-railties.rb            # entry point, requires bp3/railties
  bp3/railties.rb            # requires the railtie and version
  bp3/railties/railtie.rb    # the MailersController reopening
  bp3/railties/version.rb
```

## Testing

The spec only checks the version; the commented-out example in `spec/bp3/railties_spec.rb` would need a
Rails application. Try a change against the application (black_phoebe_3) by putting this repo's `lib`
ahead of the bundled gem.

## Dependencies

- Runtime: `railties`, `actionmailer` and `activesupport` `~> 8.1`; `bp3-core >= 0.1`
- Ruby `>= 3.2.0`

## Code Style

- RuboCop (`.rubocop.yml`): target Ruby 3.2.2, NewCops, rubocop-rake and rubocop-rspec; AbcSize 26,
  MethodLength 15, BlockLength 66, ModuleLength 150; `Lint/ConstantDefinitionInBlock` and `Lint/Void`
  are off for `lib/bp3/**/railtie.rb`, where classes are reopened inside a block
- Every file starts with `# frozen_string_literal: true`
- American English; no trailing whitespace on any added or modified line

## Release

Bump `lib/bp3/railties/version.rb` and add a `CHANGELOG.md` entry. `rake release` tags, pushes and
publishes to rubygems.org; leave releasing and committing to the user.
