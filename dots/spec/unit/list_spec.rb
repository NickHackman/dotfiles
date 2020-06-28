# frozen_string_literal: true

require 'dots/commands/list'

RSpec.describe Dots::Commands::List do
  it 'executes `list` command successfully' do
    output = StringIO.new
    options = {}
    command = Dots::Commands::List.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
