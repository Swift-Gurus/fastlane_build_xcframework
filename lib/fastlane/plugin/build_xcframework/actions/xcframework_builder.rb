require 'fastlane/action'

module Fastlane
  module Actions
    class XCFrameworkBuilder
      def self.run(config)
        temp_device_framework = config[:device_framework_filename]
        temp_sim_framework = config[:sim_framework_filename]
        framework_command_args = [temp_device_framework, temp_sim_framework].compact.reduce('') { |sum, cur| sum + " -framework " + cur }
        Actions.sh("set -o pipefail && xcodebuild -create-xcframework #{framework_command_args} -output #{config[:release_xcframework_filename]}")
      end

      def self.framework_temp_path(base, name)
        "#{base}/Products/Library/Frameworks/#{name}"
      end
    end
  end
end
