# frozen_string_literal: true

require_relative '../command'

require_relative '../../dots'
require_relative '../../config'

module Commands
  # Superclass for Dot subcommands
  class DotsCommand < Cmd::Command
    def init(validate = false)
      conf = Conf::Config.new(@options[:config], @options[:dotfiles_dir])
      begin
        dotfiles = conf.validate(validate)
      rescue StandardError => e
        abort "🚧 Config Error: #{e}\nThis is a bug, please open an issue https://github.com/NickHackman/dotfiles/issues"
      end
      Dots::Dots.new(dotfiles)
    end
  end
end
