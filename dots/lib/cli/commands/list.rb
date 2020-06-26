# frozen_string_literal: true

require_relative '../command'

require_relative '../../dots'

module Cmds
  module Commands
    # Install subcommand
    class List < Cmd::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        dots = Dots::Dots.new
        dots.list
      end
    end
  end
end
