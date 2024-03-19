# frozen_string_literal: true

module Hakari
  module Themes
    class Packer
      def initialize(source_path = Dir.pwd)
        @source_path = source_path
      end

      def pack
        buffer = StringIO.new

        Zip::OutputStream.write_buffer(buffer) do |zos|
          Dir.chdir(@source_path) do
            files = Dir.glob("**/*").reject do |file|
              ignored_files.any? { |pattern| File.fnmatch?(pattern, file) }
            end

            zos.put_next_entry("theme/")

            files.each do |file|
              zos.put_next_entry("theme/#{file}")
              zos.write(File.read(file)) unless File.directory?(file)
            end
          end
        end

        buffer.rewind
        buffer
      end

      private

      def ignored_files
        return [] unless File.exist?(".hakariignore")

        File.read(".hakariignore")
          .split("\n")
          .reject { |line| line.start_with?("#") }
          .map(&:strip)
          .reject(&:empty?)
      end
    end
  end
end
