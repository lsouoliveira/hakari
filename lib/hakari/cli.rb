# frozen_string_literal: true

require_relative "core/commands/login"
require_relative "themes/cli"

module Hakari
  class CLI < Thor
    desc "themes SUBCOMMAND ...ARGS", "Manage themes"
    subcommand "themes", Hakari::Themes::CLI

    desc "version", "Prints the version"
    def version
      art = <<~'EOF'
         _           _              _ 
        | |__   __ _| | ____ _ _ __(_)
        | '_ \ / _` | |/ / _` | '__| |
        | | | | (_| |   < (_| | |  | |
        |_| |_|\__,_|_|\_\__,_|_|  |_|
      EOF
      puts art.bold
      log("#{"Version:".colorize(:green).bold}: #{Hakari::VERSION}")
    end

    desc "login", "Login to Hakari"
    def login
      Hakari::Core::Commands::Login.new.run
    end
  end
end
