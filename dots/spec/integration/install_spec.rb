RSpec.describe "`dots install` command", type: :cli do
  it "executes `dots help install` command successfully" do
    output = `dots help install`
    expected_output = <<-OUT
Usage:
  dots install

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
