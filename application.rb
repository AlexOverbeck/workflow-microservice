require 'dotenv/load'
require 'sinatra'
require 'sinatra/reloader'

require './i18n'

get '/' do
  @languags = I18n.get_supported_languages

  slim :index
end

post '/translate' do
  content_type :json
  params['text'] = 'Hello World!' if params['text'] == ''
  params['languags'] = ['en'] if params['languags'] == []
  
  I18n.translate(params['text'], locale: params['languages']).to_json
end