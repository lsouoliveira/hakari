# frozen_string_literal: true

def log(message = "", level = :info)
  output = ""
  output += Time.now.strftime("%H:%M:%S")
  output += " "
  output += "[#{level.to_s.upcase}]".colorize(level_color(level))
  output += " "
  output += message

  puts output
end

def level_color(level)
  case level
  when :info
    :green
  when :error
    :red
  else
    :white
  end
end
