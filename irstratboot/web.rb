require 'sinatra/base'

module Irstratboot
  class Web < Sinatra::Base
    get '/' do
      'Irstrat Slack Boot.'
    end
  end
end