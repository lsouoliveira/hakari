# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Commands::List) do
  describe "#run" do
    it "should list all themes" do
      list_command = Hakari::Themes::Commands::List.new

      themes = double(items: [
        build_theme(name: "theme1"),
        build_theme(name: "theme2"),
      ])

      allow_any_instance_of(Hakari::Api::Theme)
        .to(receive(:list)
        .and_return(themes))

      expect { list_command.run }.to(output(/theme1.*theme2/im).to_stdout)
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
