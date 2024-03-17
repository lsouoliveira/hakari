# frozen_string_literal: true

require_relative "commands/list"
require_relative "commands/pull"

module Hakari
  module Themes
    class CLI < Thor
      desc "list", "List themes"
      def list
        Hakari::Themes::Commands::List.new.run
      end

      desc "pull", "Pull theme"
      def pull
        Hakari::Themes::Commands::Pull.new.run
      end
    end
  end
end
