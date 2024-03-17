# frozen_string_literal: true

module Hakari
  module Themes
    module Commands
      class Pull < Hakari::Command
        def initialize(**options)
          @destination_path = options[:destination_path] || Dir.pwd
          @progress_bar = build_progress_bar
        end

        def run
          choices = build_choices(themes)
          choice = prompt.select("Choose a theme to pull:", choices)

          output_title

          pull_theme(choice, method(:handle_progress))
        end

        private

        def build_progress_bar
          TTY::ProgressBar.new(
            ":bar :percent",
            total: 100,
            bar_format: :block,
            complete: Pastel.new.on_blue(" "),
          )
        end

        def output_title
          star = "★".colorize(:yellow).bold
          puts "#{star} Pulling theme".bold
        end

        def themes
          @_themes ||= client.themes.list
        end

        def client
          @_client ||= Hakari.api_client
        end

        def build_choices(themes)
          themes.items.map do |theme|
            {
              name: "#{theme.name} #{theme.version} (##{theme.id})",
              value: theme.id,
            }
          end
        end

        def prompt
          TTY::Prompt.new(symbols: { marker: ">" })
        end

        def pull_theme(theme_id, progress_proc)
          archive = client.themes.pull(
            theme_id,
            progress_proc,
          )
          Hakari::Themes::ThemeExtractor.new(
            archive,
            @destination_path,
          ).extract
        end

        def handle_progress(progress)
          @progress_bar.ratio = progress
        end
      end
    end
  end
end
