# frozen_string_literal: true

require 'dots/commands/remove'

RSpec.describe Dots::Commands::Remove do
  it 'executes `remove` command successfully' do
    output = StringIO.new
    options = {}
    command = Dots::Commands::Remove.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
