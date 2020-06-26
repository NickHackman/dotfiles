require_relative 'lib/dots/version'

Gem::Specification.new do |spec|
  spec.name = 'dots'
  spec.license = 'GPLv3'
  spec.version = Dots::VERSION
  spec.authors = ['NickHackman']
  spec.email = ['snickhackman@gmail.com']

  spec.summary = 'A dotfile installer'
  spec.description = 'A dotfile installer that helps you get up and running fast and keep your dotfiles synchronized'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
