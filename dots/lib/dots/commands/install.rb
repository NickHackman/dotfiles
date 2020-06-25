# frozen_string_literal: true

require_relative '../command'

require_relative '../dots'

module Cmds
  module Commands
    # Install subcommand
    class Install < Cmd::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        dots = Dots::Dots.new
        dots.install_all
      end
    end
  end
end
