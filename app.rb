require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'braille-ja'
require 'digest'

get '/translate' do
  content_type :json
  text = params[:text]
  error 400, {error: 'text required'}.to_json if text.nil?
  error 400, {error: 'text too long'}.to_json if text.length > 100

  cache_control :public, max_age: 3600
  headers "Access-Control-Allow-Origin" => 'http://tadd.github.io'
  etag Digest::SHA1.hexdigest(text)
  {translated: text.kana_to_braille}.to_json
end

DEMO_SITE = 'http://tadd.github.io/braille-ja'

get '/' do
  redirect DEMO_SITE
end
