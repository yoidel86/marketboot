module Irstratboot
  module Commands
    class Status < SlackRubyBot::Commands::Base
      command 'calculate' do |client, data, _match|
        client.say(channel: data.channel, text: '4')
      end
    end
  end
end