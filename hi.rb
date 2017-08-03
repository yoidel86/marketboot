require 'slack-ruby-client'

Slack.configure do |config|
  config.token = 'xoxb-219320094868-wKNOgP9VAGOgih3i4aMaBkm0'# ENV['SLACK_API_TOKEN']
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::INFO
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  puts data

  client.typing channel: data.channel
  case data.text
    when 'bot hi' then
      client.message channel: data.channel, text: "Hi <@#{data.user}>!"
    when 'bot intradia' then
      ejemplo = get_intradia "CADU"
    client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  # when /^bott/ then
  #   client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
end

end

client.on :close do |_data|
  puts 'Connection closing, exiting.'
end

client.on :closed do |_data|
  puts 'Connection has been disconnected.'
end
def get_intradia emiter
  url_api = "http://h-kont.herokuapp.com/api/#{emiter}"
  resp = Net::HTTP.get_response(URI.parse(url_api.strip))
  JSON.parse(resp.body)
end
client.start!