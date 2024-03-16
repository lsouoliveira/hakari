# frozen_string_literal: true

require_relative "core/commands/login"
require_relative "core/commands/whoami"
require_relative "core/commands/logout"

module Hakari
  class CLI < Thor
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
  end
end
