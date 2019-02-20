require 'sinatra'

get '/' do
  content_type :json

  {
    hello: 'Workflow Microservice'
  }.to_json
end