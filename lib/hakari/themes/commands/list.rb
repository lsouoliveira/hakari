# frozen_string_literal: true

module Hakari
  module Themes
    module Commands
      class List < Hakari::Command
        def run
          themes = Hakari.api_client.themes.list(per_page: 1000)

          output_title
          output_themes(themes)
        end

        private

        def output_title
          star = "★".colorize(:yellow).bold
          puts "#{star} List of themes:"
        end

        def output_themes(themes)
          themes.items.each { |theme| output_theme(theme) }
        end

        def output_theme(theme)
          theme_id = "##{theme.id}".colorize(:green).bold
          theme_name = "#{theme.name} #{theme.version}".bold

          puts "  #{theme_name} #{theme_id}"
        end
      end
    end
  end
end
