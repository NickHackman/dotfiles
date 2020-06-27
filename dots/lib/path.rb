# frozen_string_literal: true

require 'set'
require 'singleton'

module Path
  PATH = 'PATH'
  PATH_SEP = ':'

  # Find Dependencies installed in $PATH
  class Path
    include Singleton

    def initialize
      path_env = ENV[PATH]
      paths = path_env.split(PATH_SEP)

      # Create a Set of all files inside of $PATH
      @path = paths.each_with_object(Set.new) do |path, bin|
        if File.directory?(path)
          dir = Dir.new(path)
          dir.each_child { |child| bin << child }
        else
          bin << child
        end
      end
    end

    # Check if an application is in $PATH
    def installed?(file)
      @path.include?(file)
    end

    # Runs provided command returning True if it exited with 0 False otherwise
    def run(cmd)
      system(cmd)
    end
  end
end
