# frozen_string_literal: true

require_relative "commands/list"

module Hakari
  module Themes
    class CLI < Thor
      desc "list", "List themes"
      def list
        Hakari::Themes::Commands::List.new.run
      end
    end
  end
end
