require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'securerandom'

class I18n
  def self.translate(*args)
    new(*args).perform
  end

  def initialize(text, options={})
    host = 'https://api.cognitive.microsofttranslator.com'
    path = '/translate?api-version=3.0'
    params = '&to=de&to=it'

    @text = text
    @uri = URI (host + path + params)
  end

  def perform
    response = Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      http.request(translation_request)
    end

    JSON.parse(response.body.force_encoding("utf-8"))
  end

  def translation_request
    body = [{'Text': @text}].to_json
    request = Net::HTTP::Post.new(@uri)
    request['Content-type'] = 'application/json'
    request['Content-length'] = body.length
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_SUBSCRIPTION_KEY']
    request['X-ClientTraceId'] = SecureRandom.uuid
    request.body = body
    request
  end
end