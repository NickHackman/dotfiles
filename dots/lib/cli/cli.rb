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

    desc 'version', 'Dots version'
    map %w[--version -v] => :version

    def version
      require_relative 'version'
      puts "v#{Dots::VERSION}"
    end

    desc 'validate', 'Validate dotfile config', aliases: 'v'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :config, aliases: '--config', type: :string,
                           desc: 'Path to dotfiles config file'
    method_option :dotfiles_dir, aliases: '--dotfiles_dir', type: :string,
                                 desc: 'Path to dotfiles directory'

    def validate(*)
      if options[:help]
        invoke :help, ['validate']
      else
        require_relative 'commands/validate'
        Commands::Validate.new(options).execute
      end
    end

    desc 'list', 'List dotfiles', aliases: 'l'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :config, aliases: '--config', type: :string,
                           desc: 'Path to dotfiles config file'
    method_option :dotfiles_dir, aliases: '--dotfiles_dir', type: :string,
                                 desc: 'Path to dotfiles directory'

    def list(*)
      if options[:help]
        invoke :help, ['list']
      else
        require_relative 'commands/list'
        Commands::List.new(options).execute
      end
    end

    desc 'doctor', 'Check dependencies for all dotfiles', aliases: 'd'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :config, aliases: '--config', type: :string,
                           desc: 'Path to dotfiles config file'
    method_option :dotfiles_dir, aliases: '--dotfiles_dir', type: :string,
                                 desc: 'Path to dotfiles directory'

    def doctor(*)
      if options[:help]
        invoke :help, ['doctor']
      else
        require_relative 'commands/doctor'
        Commands::Doctor.new(options).execute
      end
    end

    desc 'remove', 'Remove installed configuration files', aliases: 'r'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :config, aliases: '--config', type: :string,
                           desc: 'Path to dotfiles config file'
    method_option :dotfiles_dir, aliases: '--dotfiles_dir', type: :string,
                                 desc: 'Path to dotfiles directory'

    def remove(*names)
      if options[:help]
        invoke :help, ['remove']
      else
        require_relative 'commands/remove'
        Commands::Remove.new(names, options).execute
      end
    end

    desc 'install', 'Install configuration files', aliases: 'i'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :copy, aliases: %w[--copy -c], type: :boolean,
                         desc: 'Instead of creating symlinks, copy dotfiles'
    method_option :config, aliases: '--config', type: :string,
                           desc: 'Path to dotfiles config file'
    method_option :dotfiles_dir, aliases: '--dotfiles_dir', type: :string,
                                 desc: 'Path to dotfiles directory'

    def install(*names)
      if options[:help]
        invoke :help, ['install']
      else
        require_relative 'commands/install'
        Commands::Install.new(names, options).execute
      end
    end
  end
end
