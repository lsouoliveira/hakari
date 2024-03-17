# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Commands::Pull) do
  describe "#run" do
    it "should pull all themes" do
      tmp_dir = Dir.mktmpdir
      pull_command = Hakari::Themes::Commands::Pull.new(
        destination_path: tmp_dir,
      )

      themes = Hakari::Api::Collection.new(
        items: [build_theme, build_theme],
        total_pages: 1,
        current_page: 1,
        total_count: 2,
      )
      dummy_prompt = double("prompt", select: themes.items.first.id)
      theme_file = File.read("spec/fixtures/theme.zip")

      allow_any_instance_of(Hakari::Api::Themes).to(receive(:list))
        .and_return(themes)
      allow(pull_command).to(receive(:prompt))
        .and_return(dummy_prompt)
      allow_any_instance_of(Hakari::Api::Themes).to(receive(:pull))
        .and_return(theme_file)

      pull_command.run

      Zip::File.open("spec/fixtures/theme.zip") do |zip_file|
        zip_file.each do |entry|
          file_path = File.join(tmp_dir, entry.name)
          unless entry.directory?
            expect(File.exist?(file_path)).to(be(true))
          end
        end
      end
    end
  end

  def build_theme(**opts)
    double(
      "theme",
      id: opts[:id] || Faker::Number.number(digits: 10),
      name: opts[:name] || Faker::Name.name,
      version: opts[:version] || Faker::App.version,
    )
  end
end
