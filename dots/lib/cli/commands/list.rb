# frozen_string_literal: true

require_relative '../../dots'
require_relative '../../config'

require_relative './command'

module Commands
  # Install subcommand
  class List < Commands::DotsCommand
    def initialize(options)
      @options = options
    end

    def execute(*)
      dots = init
      dots.list
    end
  end
end
