# frozen_string_literal: true

require 'yaml'
require 'pathname'

require_relative './dot'
require_relative './error'
require_relative './constant'

module Conf
  # dots.yml Config
  #
  # Parses YAML file and validates to uphold invariants
  class Config
    def initialize(config_path = nil, dotfiles_dir = nil)
      @dotfiles_dir = dotfiles_dir || DOTSFILES_DIR
      config_path ||= DEFAULT_PATH

      yaml = YAML.load_file(config_path)
      @hashes = yaml[DOTS]
    end

    # Validate Config to maintain all invariants
    #
    # Checks that all invariants are upheld, unless validate is false. If an invariant
    # isn't upheld this method raises an exception
    #
    # Returns Array of Dots
    def validate(validate = false)
      if validate
        @hashes&.each do |hash|
          name_invariant(hash)
          doctor_command_invariant(hash)
          destination_invariant(hash)
          install_children_invariant(hash)
          exclude_invariant(hash)
        end
      end
      @hashes.map { |hash| Dot::Dot.new(hash, @dotfiles_dir) }
    end

    private

    # name invariant
    #
    # Name MUST exist and not be empty
    def name_invariant(hash)
      name = hash[NAME]
      path = File.join(@dotfiles_dir, name)
      invariant = name && !name.empty? && File.exist?(path)
      raise Error::NameInvariantError.new(path, hash), '' unless invariant
    end

    # destination invariant
    #
    # Destination must exist if it doesn't then prompt_instructions must exist and
    # not be empty
    def destination_invariant(hash)
      prompt = hash[PROMPT_INSTRUCTIONS]
      dest = hash[DESTINATION]
      if dest
        abs_dest = File.expand_path(dest)
        invariant = File.exist?(abs_dest)
      else
        invariant = (dest.nil? && prompt && !prompt.empty?)
      end
      raise Error::DestinationInvariantError.new(hash), '' unless invariant
    end

    # install_children invariant
    #
    # install_children is optional, if it does exist
    # - @dotfiles_dir/name MUST be a directory
    # - @dotfiles_dir/name MUST have children
    def install_children_invariant(hash)
      inst_child = hash[INSTALL_CHILDREN]

      path = File.join(@dotfiles_dir, hash[NAME])
      raise Error::InstallChildrenInvariantError.new(path, hash), '' unless File.directory?(path)

      dir = Dir.new(path)
      invariant = (inst_child && !dir.children.empty?) ||
                  !inst_child
      dir.close
      raise Error::InstallChildrenInvariantError.new(path, hash), '' unless invariant
    end

    # exclude invariant
    #
    # exclude is optional, if it does exist
    # - @dotfiles/name MUST be a directory
    # - All of exclude MUST be in the directory @dotfiles/name
    def exclude_invariant(hash)
      exclude = hash[EXCLUDE]

      return unless exclude

      path = File.join(@dotfiles_dir, hash[NAME])
      raise Error::ExcludeInvariantError.new(path, hash), '' unless File.directory?(path)

      dir = Dir.new(path)
      all = exclude.all? { |excl| dir.children.include?(excl) }
      invariant = dir && all
      dir.close
      raise Error::ExcludeInvariantError.new(path, hash), '' unless invariant
    end

    # doctor_command invariant
    #
    # doctor_command is optional, if it does exist
    # - doctor_command when invoked must return 0
    def doctor_command_invariant(hash)
      doc_cmd = hash[DOCTOR_COMMAND]
      return true unless doc_cmd

      return false if doc_cmd.empty?

      quiet_cmd = "#{doc_cmd} > /dev/null 2>&1"

      invariant = system(quiet_cmd)
      raise Error::DoctorCommandInvariantError.new(hash), '' unless invariant
    end
  end
end
