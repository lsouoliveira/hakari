# frozen_string_literal: true

require_relative "commands/list"
require_relative "commands/pull"
require_relative "commands/dev"

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

      desc "dev", "Start development"
      def dev
        Hakari::Themes::Commands::Dev.new.run
        sleep
      end
    end
  end
end
