# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bp3-railties is a Ruby gem that adapts Rails' `railties` for BP3 (persuavis/black_phoebe_3), a multi-site multi-tenant Rails application. The primary purpose is to enhance `Rails::MailersController` with BP3-specific functionality.

## Development Commands

### Setup
```bash
bin/setup  # Install dependencies
```

### Testing
```bash
rake spec         # Run RSpec tests only
rake rubocop      # Run RuboCop linting only
rake              # Run both tests and linting (default task)
```

To run a single test file:
```bash
rspec spec/path/to/file_spec.rb
```

To run a specific test:
```bash
rspec spec/path/to/file_spec.rb:LINE_NUMBER
```

### Local Installation
```bash
rake install      # Install gem locally
```

### Console
```bash
bin/console       # Interactive prompt for experimentation
```

## Architecture

### Core Functionality

The gem uses a Rails Railtie to monkey-patch `Rails::MailersController` at application initialization. This happens in `lib/bp3/railties/railtie.rb:8-22`.

**Key mechanism**: After Rails initializes, the gem:
1. Preloads `Rails::MailersController`
2. Reopens the class and includes four modules from `bp3-core`:
   - `Bp3::Core::Actions`
   - `Bp3::Core::Settings`
   - `Bp3::Core::FeatureFlags`
   - `Bp3::Core::Cookies`
3. Adds a `before_action :authenticate_root!` filter

### Module Structure

```
lib/
  bp3-railties.rb              # Entry point, requires bp3/railties
  bp3/
    railties.rb                # Main module, requires railtie and version
    railties/
      railtie.rb               # Rails integration via Railtie
      version.rb               # Version constant
```

### Dependencies

- **Runtime**: `bp3-core` (>= 0.1), Rails components (`railties`, `actionmailer`, `activesupport`)
- **Rails version**: 7.1.2 to < 8.1.2
- **Ruby version**: >= 3.2.0

## RuboCop Configuration

The project uses RuboCop with the following plugins:
- rubocop-rake
- rubocop-rspec

Notable exceptions in `.rubocop.yml`:
- `Lint/ConstantDefinitionInBlock` and `Lint/Void` are disabled for railtie files (necessary for monkey-patching)
- `Naming/FileName` excludes `lib/bp3-*.rb` files
- Documentation is disabled (`Style/Documentation: false`)

## Testing Notes

The test suite uses RSpec with:
- `--only-failures` and `--next-failure` flags enabled
- Example status persistence in `.rspec_status`
- Monkey patching disabled
- Expect syntax only

Current test coverage is minimal - only verifies version constant exists. The commented-out test in `spec/bp3/railties_spec.rb:11-16` suggests intended testing of module inclusion but requires a Rails application context to run properly.

## Release Process

Per README:
1. Update version in `lib/bp3/railties/version.rb`
2. Run `rake release` (creates git tag, pushes commits/tags, publishes to rubygems.org)

## BP3 Ecosystem Context

This gem is part of the BP3 (Black Phoebe 3) ecosystem, a multi-site multi-tenant Rails application. It depends on `bp3-core` for the modules it includes into `Rails::MailersController`. The primary use case is enabling BP3's authentication, feature flags, and tenant-specific settings in the Rails mailer preview interface.
