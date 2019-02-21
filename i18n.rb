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
    @text = text
    @uri = build_uri(options.fetch(:locale, :en))
  end

  def perform(request: translation_request)
    response = Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      http.request(request)
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

  def build_uri(locales)
    url = 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0'
    puts URI(url + build_params(locales))

    URI(url + build_params(locales))
  end

  def build_params(locales)
    return "&to=#{locales}" unless locales.is_a? Array

    '&to=' + locales.map(&:to_s).join('&to=') if locales.any?
  end

  def self.get_supported_languages
    host = 'https://api.cognitive.microsofttranslator.com'
    path = '/languages?api-version=3.0'
    uri = URI(host + path)
    request = Net::HTTP::Get.new(uri)
    
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body.force_encoding("utf-8"))['translation']
  end
end