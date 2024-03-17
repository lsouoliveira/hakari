# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::ThemeExtractor) do
  describe "#extract" do
    it "should extract the files from the zip" do
      zip_file = File.open("spec/fixtures/theme.zip")
      destination_path = Dir.mktmpdir
      theme_extractor = Hakari::Themes::ThemeExtractor.new(zip_file, destination_path)

      theme_extractor.extract

      Zip::File.open("spec/fixtures/theme.zip") do |zip_file|
        zip_file.each do |entry|
          filename = File.join(destination_path, entry.name)
          expect(File.exist?(filename)).to(be(true))
        end
      end
    end
  end
end
