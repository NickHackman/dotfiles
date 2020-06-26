# frozen_string_literal: true

require_relative '../command'

require_relative '../../dots'
require_relative '../../error'

module Cmds
  module Commands
    # Install subcommand
    class Remove < Cmd::Command
      def initialize(dots, options)
        @options = options
        @dots = dots
      end

      def execute(input: $stdin, output: $stdout)
        dots = Dots::Dots.new

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
end
