# frozen_string_literal: true

require_relative '../command'

require_relative '../../dots'
require_relative '../../error'

module Cmds
  module Commands
    # Install subcommand
    class Doctor < Cmd::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        dots = Dots::Dots.new
        dots.doctor_all
      end
    end
  end
end
