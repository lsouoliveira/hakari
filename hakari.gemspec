# frozen_string_literal: true

require_relative "lib/hakari/version"

Gem::Specification.new do |spec|
  spec.name = "hakari"
  spec.version = Hakari::VERSION
  spec.authors = ["Lucas Sousa"]
  spec.email = ["ls442336@gmail.com"]

  spec.summary = "A CLI tool to manage themes."
  spec.description = "A CLI tool to manage themes."
  spec.homepage = "https://github.com/lsouoliveira/hakari"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lsouoliveira/hakari"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?("bin/", "test/", "spec/", "features/", ".git", ".github", "appveyor", "Gemfile")
    end
  end
  spec.bindir = "bin"
  spec.executables = ["hakari"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency("colorize", "~> 1.1")
  spec.add_dependency("down", "~> 5.4.1")
  spec.add_dependency("faraday", "~> 2.9.0")
  spec.add_dependency("faraday-multipart", "~> 1.0.4")
  spec.add_dependency("launchy", "~> 3.0")
  spec.add_dependency("listen", "~> 3.9.0")
  spec.add_dependency("rubyzip", "~> 2.3.2")
  spec.add_dependency("thor", "~> 1.3.1")
  spec.add_dependency("tty-box", "~> 0.7.0")
  spec.add_dependency("tty-link", "~> 0.1.1")
  spec.add_dependency("tty-progressbar", "~> 0.18.2")
  spec.add_dependency("tty-prompt", "~> 0.23.1")
end
