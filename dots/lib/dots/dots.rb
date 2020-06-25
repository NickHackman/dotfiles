# frozen_string_literal: true

require 'yaml'
require 'pathname'

require 'levenshtein'
require 'tty-prompt'

require_relative './command'
require_relative './dot'

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
      puts '🚀 Installing...'
      selected.each(&:install_symlink)
    end

    # Remove all selected dotfiles
    def remove_all
      prompt = Cmd::Command.prompt
      selected = prompt.multi_select('Select to delete', @dots, per_page: 10, cycle: true)
      puts '🧼 Cleaning...'
      selected.each(&:remove)
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

    # Find the most similar dotfile name listed in 'dots/dots.yml'
    #
    # If the distance between input and the minimum name is
    # less than or equal to 3 the minimum name is returned else nil
    def find_similar_dot(input)
      min_dist = 4
      min = @dots.min_by do |dot|
        dist = Levenshtein.distance(input, dot.name)
        min_dist = dist if min_dist > dist
        dist
      end
      min_dist <= 3 ? min.name : nil
    end
  end
end
