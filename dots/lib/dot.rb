# frozen_string_literal: true

require 'fileutils'

require_relative './cli/command'

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
    #   "destination": "destination",
    #   "install_children": true
    # }
    def initialize(hash, src_base_path)
      @name = hash['name']
      @destination = File.expand_path(hash['destination']) if hash['destination']
      @install_children = hash.key?('install_children') && hash['install_children']
      @source = src_base_path + @name
      @exclude = hash['exclude']
      @prompt_instructions = hash['prompt_instructions']
    end

    # Installs the dotfile as a symlink
    #
    # Throws if @source doesn't exist
    def install_symlink
      install { |src, dest| File.symlink(src, dest) }
    end

    # Copies the dotfile to the destination
    def install_copy
      install { |src, dest| FileUtils.cp(src, dest) }
    end

    # returns name of Dot
    def to_s
      @name
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
      dir.entries.filter { |f| !%w[. ..].include?(f) || @exclude&.include?(f) }
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

      File.delete(path) if prompt.yes?("🚧 Remove '#{path}'?")
    end

    # Install a file check to see whether or not to overwrite the current file
    def install_or_overwrite(src, dest)
      prompt = Cmd::Command.prompt

      File.delete(dest) if File.exist?(dest) && prompt.yes?("🚧 Overwrite '#{dest}'?")
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

    # Handles case of @destination is nil
    #
    # Which means that the user must be prompted to find the path at runtime,
    # because it's impossible to determine otherwise
    def install_prompt
      prompt = Cmd::Command.prompt
      keep_asking = true
      is_dir = false
      while keep_asking
        dir = prompt.ask("#{@prompt_instructions}:", required: true) do |q|
          q.modify :trim
        end

        is_dir = File.directory?(dir)
        puts "😮 that's not a directory" unless is_dir
        keep_asking = !is_dir && prompt.yes?('🥺 Try again?')
      end
      @destination = dir

      return unless is_dir

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
