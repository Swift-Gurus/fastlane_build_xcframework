require 'fastlane/action'

module Fastlane
  module Actions
    class BuildUtils
      def self.prepare(config)
        UI.important("Preparing folders")
        UI.message("Removing old: #{config[:base]}")
        FileUtils.rm_rf(config[:release_folder])
        UI.message("Creating empty: #{config[:release_folder]}")
        Actions.sh("set -o pipefail && mkdir -p #{config[:release_folder]}")
      end

      def self.clean_temp_folder(config)
        UI.message("Clearing derived data folder: #{config[:derived_data]}")
        FileUtils.rm_rf(config[:derived_data])
      end
    end
  end
end
