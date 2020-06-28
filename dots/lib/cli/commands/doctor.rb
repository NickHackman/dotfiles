# frozen_string_literal: true

require_relative '../../dots'
require_relative '../../error'
require_relative '../../config'

require_relative './command'

module Commands
  # Install subcommand
  class Doctor < Commands::DotsCommand
    def initialize(options)
      @options = options
    end

    def execute(input: $stdin, output: $stdout)
      dots = init
      dots.doctor_all
    end
  end
end
