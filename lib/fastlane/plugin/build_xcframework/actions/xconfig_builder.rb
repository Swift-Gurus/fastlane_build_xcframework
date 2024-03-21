module Fastlane
  class XconfigBuilder
    @paths_components = {}
    @params = {}

    class << self
      attr_reader :params
      attr_writer(:params)
      attr_reader :paths_components
      attr_writer(:paths_components)
    end

    def self.prepare_config(simulator)
      xcodebuild_configs = base_config
      archs = params[:sim_archs]

      if simulator == true
        xcodebuild_configs[:sdk] = 'iphonesimulator'
        xcodebuild_configs[:configuration] = params[:configuration]

        archs = params[:sim_archs]
      else
        xcodebuild_configs[:sdk] = 'iphoneos'
        xcodebuild_configs[:configuration] = params[:sim_configuration]
        archs = params[:dev_archs]
      end
      # if params[:type] == 'xcframework'
      path = "#{paths_components[:derived_data]}/#{xcodebuild_configs[:sdk]}/#{paths_components[:project_name]}"
      xcodebuild_configs[:archive_path] = path
      destination = ''
      if simulator
        destination = "generic/platform=iOS Simulator"
      else
        destination = "generic/platform=iOS"
      end
      xcodebuild_configs[:destination] = destination
      # end

      if archs
        xcodebuild_configs[:xcargs] += ' ' + archs.reduce('') { |sum, cur| sum + " -arch " + cur }
      end
      if simulator == true && params[:type] == 'framework'
        xcodebuild_configs[:xcargs] += ' ' + "EXCLUDED_ARCHS=\"arm64\""
      end
      xcodebuild_configs
    end

    def self.simulator_config
      prepare_config(true)
    end

    def self.device_config
      prepare_config(false)
    end

    def self.base_config
      case params[:type]
      when 'framework'
        xcodebuild_configs = static_framework_settings
        # xcodebuild_configs[:derivedDataPath] = paths_components[:derived_data]
      when 'xcframework'
        xcodebuild_configs = xc_framework_settings
      else
        xcodebuild_configs = {}
      end
      xcodebuild_configs[:project] = params[:project]
      xcodebuild_configs[:workspace] = params[:workspace]
      xcodebuild_configs[:scheme] =  params[:scheme] || paths_components[:project_name]
      xcodebuild_configs[:xcargs] = ''
      xcodebuild_configs
    end

    def self.static_framework_settings
      {
        only_active_arch: false,
        archive: true,
        defines_module: false
      }
    end

    def self.xc_framework_settings
      {
        only_active_arch: false,
        archive: true,
        defines_module: false
      }
    end
  end
end
