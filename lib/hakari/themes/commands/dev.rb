# frozen_string_literal: true

module Hakari
  module Themes
    module Commands
      class Dev < Hakari::Command
        def initialize(**opts)
          @source_path = opts[:source_path] || Dir.pwd
        end

        def run
          development_theme_id = storage.retrieve("development_theme_id")

          if development_theme_id
            launch(development_theme_id)
          else
            theme = setup_development_theme
            launch(theme.id)
          end
        end

        private

        def storage
          @_storage ||= Hakari.storage
        end

        def launch(theme_id)
          output_dev_screen(theme_id)

          syncer = Hakari::Themes::Syncer.new
          syncer.start

          watcher = Hakari::Themes::Watcher.new(@source_path, syncer, theme_id)
          watcher.start
        end

        def output_dev_screen(theme_id)
          print(build_box { box_content(theme_id) })
        end

        def build_box(&block)
          TTY::Box.frame(
            width: TTY::Screen.width,
            padding: [0, 1, 0, 1],
            enable_color: true,
            style: {
              border: {
                fg: :blue,
              },
            },
            title: {
              top_left: "Dev",
              bottom_right: "v#{Hakari::VERSION}",
            },
            &block
          )
        end

        def box_content(theme_id)
          <<~EOF
            #{"Preview your theme".bold}
            #{TTY::Link.link_to("", theme_preview_url(theme_id))}

            #{"Next steps".bold}
            1. Open your browser and navigate to the preview URL
            2. Start developing your theme

            (Ctrl+C to stop)
          EOF
        end

        def setup_development_theme
          packer = Hakari::Themes::Packer.new(@source_path)
          package = packer.pack

          puts __dir__ + "/../../assets/640x480.jpg"

          theme = Hakari.api_client.themes.create(
            name: "Development Theme #{SecureRandom.hex(4)}",
            description: "A theme for development",
            version: "1.0.0",
            file: package,
            thumbnail: File.open(__dir__ + "/../../assets/640x480.jpg"),
            demo: File.open(__dir__ + "/../../assets/1920x1080.jpg"),
            mobile_demo: File.open(__dir__ + "/../../assets/320x240.jpg"),
          )

          Hakari.storage.store("development_theme_id", theme.id)

          theme
        end

        def theme_preview_url(theme_id)
          store_slug = "slug".bold
          "#{Hakari.configuration.oauth_provider_url}/#{store_slug}?preview_theme_id=#{theme_id}".colorize(:blue)
        end
      end
    end
  end
end
