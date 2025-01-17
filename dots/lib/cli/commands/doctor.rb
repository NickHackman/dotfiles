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

    def execute(*)
      dots = init
      dots.doctor_all(@options[:no_cmd])
    end
  end
end
