# frozen_string_literal: true

require_relative '../../dots'
require_relative '../../error'
require_relative '../../config'

require_relative './command'

module Commands
  # Install subcommand
  class Remove < Commands::DotsCommand
    def initialize(dots, options)
      @options = options
      @dots = dots
    end

    def execute(*)
      dots = init

      if @dots.empty?
        dots.remove_all
      else
        puts '🧼 Cleaning...'
        @dots.each do |dot|
          begin
            dots.remove(dot)
          rescue Error::UnknownDot
            break
          end
        end
      end
    end
  end
end
