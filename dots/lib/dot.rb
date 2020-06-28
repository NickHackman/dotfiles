# frozen_string_literal: true

require 'fileutils'

require_relative './cli/command'
require_relative './path'
require_relative './constant'

module Dot
  # Dataclass that stores information about a singular Dotfile or Dot for short.
  class Dot
    attr_reader :name, :destination, :source, :install_children

    # Expects a hash, and base path to source file.
    # The concatination of 'src_base_path' + hash['name'] should result
    # in the path to the directory or file
    #
    # Hash:
    #
    # {
    #   "name": "name",
    #   "destination": "place-to-install",
    #   "install_children": true,
    #   "prompt_instructions": "Only present if destination is 'null'",
    #   "exclude": [],
    #   "depdencies": [
    #     "itself"
    #     "other_dep"
    #   ],
    #   doctor_command: "sh command"
    # }
    def initialize(hash, src_base_path)
      dest = hash[DESTINATION]
      inst_child = hash[INSTALL_CHILDREN]

      @name = hash[NAME]
      @destination = File.expand_path(dest) if dest
      @install_children = hash.key?(inst_child) && inst_child
      @source = src_base_path + @name
      @exclude = hash[EXCLUDE]
      @deps = hash[DEPENDENCIES]
      @doctor_command = hash[DOCTOR_COMMAND]
      @prompt_instructions = hash[PROMPT_INSTRUCTIONS]
    end

    # Installs the dotfile as a symlink
    #
    # Throws if @source doesn't exist
    def install_symlink
      install { |src, dest| File.symlink(src, dest) }
    end

    # Copies the dotfile to the destination
    def install_copy
      install { |src, dest| FileUtils.cp_r(src, dest) }
    end

    # returns name of Dot
    def to_s
      @name
    end

    # Checks to see if dependencies are installed and runs associated 'doctor' command
    # if it exists
    def doctor
      path = Path::Path.instance
      puts "🩺 Checkup for #{@name}"
      if @deps.nil?
        puts '   ✅ Nothing needed'
      else
        @deps.each do |dep|
          if path.installed?(dep)
            puts "   ✅ Found #{dep}"
          else
            puts "   ❌ Couldn't find #{dep}"
          end
        end
      end
      path.run(@doctor_command) if @doctor_command
    end

    # Delete Dot
    def remove
      return rm(@destination) unless @install_children

      children.each do |child|
        path = File.join(@destination, child)
        rm(path)
      end
    end

    # Get an array of children
    def children
      dir = Dir.new(@source)
      children = dir.children.filter { |f| @exclude&.include?(f) }
      dir.close
      children
    end

    # is Dot installed locally?
    #
    # Optionally takes source and destination.
    # Meant to be used with Children
    #
    # If destination is a symlink, true if destination is a symlink to source
    # If destination is a file, true if source == destination
    # If destination is a directory, compare all files in source with
    #   same named in destination
    def installed?(source = nil, destination = nil)
      src = source || @source
      dest = destination || @destination

      return false unless File.exist?(dest)

      return File.realpath(dest) == src.to_s if File.symlink?(dest)

      src_is_dir = File.directory?(src)
      dest_is_dir = File.directory?(dest)

      return FileUtils.compare_file(src, dest) if !src_is_dir && !dest_is_dir

      return false unless src_is_dir && dest_is_dir

      children.each do |child|
        src_child = File.join(src, child)
        dest_child = File.join(dest, child)
        return false unless FileUtils.compare_file(src_child, dest_child)
      end

      true
    end

    private

    # Delete file with prompt
    def rm(path)
      prompt = Cmd::Command.prompt

      if path.nil?
        puts "❌ '#{@name}' cannot be removed by dots..."
        return
      elsif !File.exist?(path)
        puts "💤 '#{path}' doesn't exist, nothing to do..."
        return
      end

      FileUtils.rm_rf(path) if prompt.yes?("🚧 Remove '#{path}'?")
    end

    # Install a file check to see whether or not to overwrite the current file
    def install_or_overwrite(src, dest)
      prompt = Cmd::Command.prompt

      FileUtils.rm_rf(dest) if File.exist?(dest) && prompt.yes?("🚧 Overwrite '#{dest}'?")
      yield(src, dest) unless File.exist?(dest)
    end

    # Install children of Dot directory
    #
    # Throws if @source is not a directory
    def _install_children
      raise "'#{@source}' is not a directory" unless File.directory?(@source)

      children.each do |child|
        next if @exclude&.include?(child)

        dest = File.join(@destination, child)
        src = File.join(@source, child)
        install_or_overwrite(src, dest) { |ch, des| yield(ch, des) }
      end
    end

    # Prompt for directory to install dotfile def to
    #
    # Called when @destination = nil
    def dir_prompt
      prompt = Cmd::Command.prompt
      dir = ''
      loop do
        dir = prompt.ask("#{@prompt_instructions}:", required: true) do |q|
          q.modify :trim
        end
        is_dir = File.directory?(dir)
        puts "😮 that's not a directory" unless is_dir
        break if !is_dir && prompt.yes?('🥺 Try again?')
      end

      return nil unless File.directory?(dir)

      dir
    end

    # Handles case of @destination is nil
    #
    # Which means that the user must be prompted to find the path at runtime,
    # because it's impossible to determine otherwise
    def install_prompt
      dir = dir_prompt
      return if dir.nil?

      @destination = dir

      _install_children { |src, dest| yield(src, dest) }
    end

    # Install Dot
    #
    # Takes a block that it invokes attempting to install a file
    #
    # Throws if @source does not exist
    def install
      raise "'#{@source}' does not exist" unless File.exist?(@source)

      if @install_children
        _install_children { |src, dest| yield(src, dest) }
      elsif @destination.nil?
        install_prompt { |src, dest| yield(src, dest) }
      else
        install_or_overwrite(@source, @destination) { |src, dest| yield(src, dest) }
      end
    end
  end
end
