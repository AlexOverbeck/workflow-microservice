require 'dotenv/load'
require 'sinatra'

require './i18n'

get '/' do
  @languags = I18n.get_supported_languages

  slim :index
end

post '/translate.json' do
  content_type :json

  data = JSON.parse(request.body.read)
  data['text'] = 'Hello World!' if data['text'] == ''
  data['locale'] = 'en' if data['locale'].nil?
  translation_data = I18n.translate(data['text'], locale: data['locale'])
  translation = Array(translation_data.first['translations']).first

  {
    locale: translation['to'],
    text: translation['text']
  }.to_json
end

post '/bulk_translate.json' do
  content_type :json
  params['text'] = 'Hello World!' if params['text'] == ''
  params['languages'] = ['en'] if params['languags'] == []
  
  I18n.translate(params['text'], locale: params['languages']).to_json
end