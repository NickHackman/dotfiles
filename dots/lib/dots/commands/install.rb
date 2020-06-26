# frozen_string_literal: true

require_relative '../command'

require_relative '../dots'
require_relative '../error'

module Cmds
  module Commands
    # Install subcommand
    class Install < Cmd::Command
      def initialize(dots, options)
        @dots = dots
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        dots = Dots::Dots.new

        if @dots.empty?
          dots.install_all
        else
          puts '🚀 Installing...'
          @dots.each do |dot|
            begin
              dots.install(dot)
            rescue Error::UnknownDot
              break
            end
          end
        end
      end
    end
  end
end
