# frozen_string_literal: true

require_relative '../../dots'
require_relative '../../error'
require_relative '../../config'

require_relative './command'

module Commands
  # Install subcommand
  class Validate < Commands::DotsCommand
    def initialize(options)
      @options = options
    end

    def execute(input: $stdin, output: $stdout)
      init(true)
      puts '✅ Looks good'
    end
  end
end
