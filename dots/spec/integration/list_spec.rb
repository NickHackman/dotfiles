RSpec.describe '`dots list` command', type: :cli do
  it 'executes `dots help list` command successfully' do
    output = `dots help list`
    expected_output = <<-OUT
Usage:
  dots list

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
