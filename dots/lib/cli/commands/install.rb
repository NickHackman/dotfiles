# frozen_string_literal: true

require_relative '../../dots'
require_relative '../../error'
require_relative '../../config'

require_relative './command'

module Commands
  # Install subcommand
  class Install < Commands::DotsCommand
    def initialize(dots, options)
      @dots = dots
      @options = options
    end

    def execute(*)
      dots = init

      if @dots.empty?
        dots.install_all(@options[:copy])
      else
        puts '🚀 Installing...'
        @dots.each do |dot|
          begin
            dots.install(dot, @options[:copy])
          rescue Error::UnknownDot
            break
          end
        end
      end
    end
  end
end
