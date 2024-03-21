require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class Object
      def self.copy(obj)
        obj.clone.tap do |new_obj|
          new_obj.each do |key, val|
            new_obj[key] = deep_clone(val) if val.kind_of?(Hash)
          end
        end
      end
    end
  end
end
