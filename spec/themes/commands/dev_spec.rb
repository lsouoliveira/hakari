# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Hakari::Themes::Commands::Dev) do
  describe "#run" do
    context "when development theme id is stored" do
      context "when the file system changes" do
        it "should update the development theme" do
          stub_api_request(:patch, "themes/1", stub_response("themes/create.json"))
          Hakari.storage.store("development_theme_id", 1)

          tmp_dir = Dir.mktmpdir
          command = Hakari::Themes::Commands::Dev.new(source_path: tmp_dir)

          command.run
          sleep 1

          expect do
            FileUtils.touch("#{tmp_dir}/file")
            sleep(1)
          end.to(output(/theme synced/im).to_stdout_from_any_process)
        end
      end
    end

    context "when development theme id is not stored" do
      it "should save the development theme id" do
        stub_api_request(:post, "themes", stub_response("themes/create.json"))

        command = Hakari::Themes::Commands::Dev.new(
          source_path: "spec/fixtures/theme",
        )

        expect { command.run }.to(change do
          Hakari.storage.retrieve("development_theme_id")
        end.from(nil).to(2))
      end
    end
  end
end
