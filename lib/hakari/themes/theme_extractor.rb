# frozen_string_literal: true

module Hakari
  module Themes
    class ThemeExtractor
      def initialize(zip_file, destination_path)
        @zip_file = zip_file
        @destination_path = destination_path
      end

      def extract
        Zip::File.open_buffer(@zip_file) do |zip_file|
          single_dir = files_inside_the_same_dir?(zip_file.entries)

          zip_file.each do |entry|
            filename = single_dir ? remove_base_dir(entry.name) : entry.name
            file_path = File.join(@destination_path, filename)
            FileUtils.mkdir_p(File.dirname(file_path))
            zip_file.extract(entry, file_path) unless File.exist?(file_path)
          end
        end
      end

      private

      def files_inside_the_same_dir?(entries)
        entries.map { |entry| entry.name.split("/").first }.uniq.size == 1
      end

      def remove_base_dir(filepath)
        filepath.split("/")[1..-1].join("/")
      end
    end
  end
end
