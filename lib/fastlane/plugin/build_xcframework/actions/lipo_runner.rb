require 'fastlane/action'

module Fastlane
  module Actions
    class LipoRunner
      def self.run(config)
        Actions.sh("set -o pipefail && cp -r #{config[:device_framework_filename]} #{config[:release_framework_filename]}")
        release_binary_path = binary_path(config[:release_framework_filename], config[:project_name])
        temp_device_binary_path = binary_path(config[:device_framework_filename], config[:project_name])
        args = release_binary_path + ' ' + temp_device_binary_path

        if config[:includeSimulator]
          UI.message('merging with simulator')
          sim_binary_path = binary_path(config[:sim_framework_filename], config[:project_name])
          args += " #{sim_binary_path}"
        end
        Actions.sh("set -o pipefail && lipo -create -output #{args}")
      end

      def self.binary_path(filename, proejct_name)
        "#{filename}/#{proejct_name}"
      end
    end
  end
end
