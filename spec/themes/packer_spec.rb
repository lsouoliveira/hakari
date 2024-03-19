# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Packer) do
  describe "#pack" do
    it "should pack the files into a zip" do
      tmp_dir = Dir.mktmpdir

      packer = Hakari::Themes::Packer.new("spec/fixtures/theme")
      package = packer.pack

      expected_files = Dir.glob("spec/fixtures/theme/**/*")
        .map { |file| file.sub("spec/fixtures/theme/", "") }
        .sort

      Zip::File.open_buffer(package) do |zip_file|
        entries = zip_file.entries.map(&:name)
          .map { |file| file.sub("theme/", "") }
          .filter { |file| file != "" }
          .sort

        expect(entries).to(eq(expected_files))
      end
    end
  end
end
