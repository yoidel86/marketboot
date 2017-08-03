require 'slack-ruby-bot'
require 'yahoo-finance'

SlackRubyBot::Client.logger.level = Logger::WARN

class MarketBot < SlackRubyBot::Bot
  scan(/^intradia ([A-Z]{2,5}+)/) do |client, data, stocks|
    p stocks
    stocks.each do |stock|
      quote = get_intradia stock[0]
      p quote
      client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [
              {
                  fallback: "#{stock} : $#{quote["intradia"]["price"]}",
                  title: "#{stock} (#{quote["intradia"]["serie"]})",
                  text: "$#{quote["intradia"]["lastprice"]} (#{quote["intradia"]["percent"]})",
                  color: quote["intradia"]["change"].to_f > 0 ? '#00FF00' : '#FF0000'
              }
          ]
      )
    end
  end

  scan(/^status/) do |client, data, stocks|
  url_api = "http://h-kont.herokuapp.com/api/fstatus"
  resp = Net::HTTP.get_response(URI.parse(url_api.strip))
  quote = JSON.parse(resp.body)
  p quote
      client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [
              {
                  fallback: "#{quote["Time_in_message"]}",
                  title: "(#{quote["Date"]})",
                  text: "$#{resp.body}",
                  color:  '#00FF00' #: '#FF0000'
              }
          ]
      )
    end
  end

  #     YahooFinance::Client.new.quotes(stocks, [:name, :symbol, :last_trade_price, :change, :change_in_percent]).each do |quote|
  #       next if quote.symbol == 'N/A'
  #       client.web_client.chat_postMessage(
  #         channel: data.channel,
  #         as_user: true,
  #         attachments: [
  #           {
  #             fallback: "#{quote.name} (#{quote.symbol}): $#{quote.last_trade_price}",
  #             title: "#{quote.name} (#{quote.symbol})",
  #             text: "$#{quote.last_trade_price} (#{quote.change_in_percent})",
  #             color: quote.change.to_f > 0 ? '#00FF00' : '#FF0000'
  #           }
  #         ]
  #       )
  #     end
#end
def get_intradia emiter
  url_api = "http://h-kont.herokuapp.com/api/intradia/#{emiter}"
  resp = Net::HTTP.get_response(URI.parse(url_api.strip))
  JSON.parse(resp.body)
end

MarketBot.run