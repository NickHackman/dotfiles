require 'dots/commands/install'

RSpec.describe Dots::Commands::Install do
  it "executes `install` command successfully" do
    output = StringIO.new
    options = {}
    command = Dots::Commands::Install.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
