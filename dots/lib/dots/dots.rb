# frozen_string_literal: true

require 'yaml'
require 'pathname'

require 'tty-prompt'

require_relative './command'
require_relative './dot'
require_relative './error'

module Dots
  DOTS_YAML_PATH = 'dots.yml'

  # docs
  class Dots
    def initialize
      # Get dotfiles/dots
      dots_dir = Pathname.new(File.expand_path(__dir__)).parent.parent
      dotfiles_dir = dots_dir.parent
      yaml = YAML.load_file(dots_dir + DOTS_YAML_PATH)
      @dots = yaml['dots'].map { |hash| Dot::Dot.new(hash, dotfiles_dir) }
    end

    # Install all selected dotfiles
    def install_all
      prompt = Cmd::Command.prompt
      selected = prompt.multi_select('Select to install', @dots, per_page: 10, cycle: true)
      puts '🚀 Installing...' unless selected.empty?
      selected.each(&:install_symlink)
    end

    # Installs a specific dot by name
    #
    # Raises If name isn't a valid Dot
    def install(name)
      found = @dots.find { |d| d.name == name }
      unknown_dot(found, name)
      found.install_symlink
    end

    # Remove all selected dotfiles
    def remove_all
      prompt = Cmd::Command.prompt
      selected = prompt.multi_select('Select to delete', @dots, per_page: 10, cycle: true)
      puts '🧼 Cleaning...' unless selected.empty?
      selected.each(&:remove)
    end

    # Removes a specific dot by name
    #
    # Raises If name isn't a valid Dot
    def remove(name)
      found = @dots.find { |d| d.name == name }
      unknown_dot(found, name)
      found.remove
    end

    # List all dotfiles an icon corresponding to whether they're
    # installed and the path to where they're installed to
    def list
      puts "📜 Listing...\n\n"
      @dots.each do |dot|
        if dot.destination.nil?
          print '❓'
        elsif dot.install_children
          print '📁'
        elsif dot.installed?
          print '✅'
        else
          print '❌'
        end
        dest = "[#{dot.destination}]" unless dot.install_children || dot.destination.nil?
        printf(" %-20s %s\n", dot.to_s, dest)
        next unless dot.install_children

        dot.children.each do |child|
          dest = File.join(dot.destination, child)
          src = File.join(dot.source, child)
          print '   '
          if dot.installed?(src, dest)
            print '✅'
          else
            print '❌'
          end
          printf(" %-17s [%s]\n", child, dest)
        end
      end
    end

    private

    # check if unknown dotfile
    #
    # Raises exception Error::UnknownDot
    def unknown_dot(found, name)
      return if found

      prompt = Cmd::Command.prompt
      sug_text = "❓ No such dotfile #{name}, did you mean?"

      prompt.suggest(name, @dots.map(&:name),
                     indent: 4, single_text: sug_text, plural_text: sug_text)
      raise Error::UnknownDot.new, 'Unknown dotfile'
    end
  end
end
