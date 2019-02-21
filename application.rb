require 'dotenv/load'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'

require './i18n'

get '/' do
  content_type :json
  
  I18n.translate('Does this sentence make sense in German?').to_json
end