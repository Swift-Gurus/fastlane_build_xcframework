lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/build_xcframework/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-build_xcframework'
  spec.version       = Fastlane::BuildXcframework::VERSION
  spec.author        = 'Alex Crowe'
  spec.email         = 'alexei.hmelevski@gmail.com'

  spec.summary       = 'This plugin provides high-level api for creating xcframework'
  spec.homepage      = "https://github.com/Swift-Gurus/fastlane_build_xcframework"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency "pathname", '~> 0.3.0'
end
