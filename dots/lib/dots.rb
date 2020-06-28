# frozen_string_literal: true

require 'yaml'
require 'pathname'

require_relative './cli/command'
require_relative './dot'
require_relative './error'
require_relative './constant'

module Dots
  # Entry point for Dots application
  #
  # Handles installing, removing, listing, and doctoring for all dotfiles
  class Dots
    def initialize(dots)
      @dots = dots
    end

    # Install all selected dotfiles
    def install_all(copy = false)
      prompt = Cmd::Command.prompt
      selected = prompt.multi_select('Select to install', @dots, per_page: PAGINATION, cycle: true)
      puts '🚀 Installing...' unless selected.empty?
      selected.each { |sel| copy ? sel.install_copy : sel.install_symlink }
    end

    # Installs a specific dot by name
    #
    # Raises If name isn't a valid Dot
    def install(name, copy = false)
      found = @dots.find { |d| d.name == name }
      unknown_dot(found, name)
      copy ? found.install_copy : found.install_symlink
    end

    # Remove all selected dotfiles
    def remove_all
      prompt = Cmd::Command.prompt
      selected = prompt.multi_select('Select to delete', @dots, per_page: PAGINATION, cycle: true)
      puts '🧼 Cleaning...' unless selected.empty?
      selected.each(&:remove)
    end

    # Doctor on all dotfiles
    def doctor_all
      puts '🏥 The doctor is here to see you now...'
      @dots.each(&:doctor)
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
