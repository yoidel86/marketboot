$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load('development.env')
puts ENV["SLACK_API_TOKEN"]
require 'irstratboot'
require 'irstratboot/web'

Thread.abort_on_exception = true

Thread.new do
  begin
    Irstratboot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Irstratboot::Web