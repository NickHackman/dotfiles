# frozen_string_literal: true

require 'thor'

module Dots
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'dots version'

    def version
      require_relative 'version'
      puts "v#{Dots::VERSION}"
    end

    map %w[--version -v] => :version

    desc 'list', 'List dotfiles'
    method_option aliases: 'l'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def list(*)
      if options[:help]
        invoke :help, ['list']
      else
        require_relative 'commands/list'
        Cmds::Commands::List.new(options).execute
      end
    end

    desc 'remove', 'Remove installed configuration files'
    method_option aliases: 'r'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def remove(*names)
      if options[:help]
        invoke :help, ['remove']
      else
        require_relative 'commands/remove'
        Cmds::Commands::Remove.new(names, options).execute
      end
    end

    desc 'install', 'Install configuration files'
    method_option aliases: 'i'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def install(*names)
      if options[:help]
        invoke :help, ['install']
      else
        require_relative 'commands/install'
        Cmds::Commands::Install.new(names, options).execute
      end
    end
  end
end
