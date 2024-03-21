require "pathname"

module Fastlane
  class PathBuilder
    def self.build_paths(config)
      base = config[:output_folder]
      derived = base + '/derivedData'
      file_name = config[:project] || config[:workspace] || detect_file("*.xcworkspace") || detect_file("*.xcodeproj")

      UI.important("Detected file name: #{file_name}")

      configuration = config[:configuration]
      sim_configuration = config[:sim_configuration]
      name = ''

      path = Pathname.new(file_name)
      file_name = path.basename.to_s || file_name
      if file_name
        name = file_name.split('.').first
      end

      if name.nil? || name.empty?
        UI.error("Could not find project or workspace")
        raise StandardError, "Could not find project or workspace"
      end

      UI.important("Detected project name: #{name}")
      framework_name = name + '.framework'
      xcframework_name = name + '.xcframework'
      release_folder = base

      temp_folder_config = {
        derived: derived,
        name: name
      }

      sim_temp_folder_cfg = deep_clone(temp_folder_config)
      sim_temp_folder_cfg[:os] = 'iphonesimulator'
      sim_temp_folder_cfg[:config] = sim_configuration

      dev_temp_folder_cfg = deep_clone(temp_folder_config)
      dev_temp_folder_cfg[:os] = 'iphoneos'
      dev_temp_folder_cfg[:config] = configuration

      {
          out_base: base,
          derived_data: derived,
          buildlog_path: derived + "/logs",
          project_name: name,
          release_folder: release_folder,
          release_framework_filename: release_folder + "/#{framework_name}",
          release_xcframework_filename: release_folder + "/#{xcframework_name}",
          device_framework_filename: temp_folder(dev_temp_folder_cfg) + "/#{framework_name}",
          sim_framework_filename: temp_folder(sim_temp_folder_cfg) + "/#{framework_name}",
          build_path_device: temp_folder(dev_temp_folder_cfg).to_s,
          build_path_sim: temp_folder(sim_temp_folder_cfg).to_s
      }
    end

    def self.deep_clone(obj)
      obj.clone.tap do |new_obj|
        new_obj.each do |key, val|
          new_obj[key] = deep_clone(val) if val.kind_of?(Hash)
        end
      end
    end

    def self.temp_folder(cfg)
      return cfg[:derived] + "/#{cfg[:os]}/#{cfg[:name]}.xcarchive/Products/Library/Frameworks"
    end

    def self.detect_file(name)
      file = nil
      files = Dir.glob(name)

      if files.length > 1
        UI.important("Multiple files detected.")
      end

      unless files.empty?
        file = files.first
        UI.important("Using file \"#{file}\"")
      end

      return file
    end
  end
end
