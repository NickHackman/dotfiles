RSpec.describe '`dots remove` command', type: :cli do
  it 'executes `dots help remove` command successfully' do
    output = `dots help remove`
    expected_output = <<-OUT
Usage:
  dots remove

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
