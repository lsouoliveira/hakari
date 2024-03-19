# frozen_string_literal: true

module Hakari
  module Api
    class Object < OpenStruct
      def initialize(obj)
        super(self.class.to_ostruct(obj))
      end

      def self.to_ostruct(obj)
        if obj.is_a?(Hash)
          OpenStruct.new(obj.transform_values { |value| to_ostruct(value) })
        elsif obj.is_a?(Array)
          obj.map { |value| to_open_struct(value) }
        else
          obj
        end
      end
    end
  end
end
