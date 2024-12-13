RSpec.shared_context "debug setup" do
  if ARGV[1] == 'debug' || ENV['DEBUG'].present?
    # rubocop:disable Lint/Debugger
    require 'byebug'

    debugger
    # rubocop:enable Lint/Debugger
  end
end
