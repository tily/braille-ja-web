require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'braille-ja'

get '/translate' do
  content_type :json
  text = params[:text]
  error 400, {error: 'text required'}.to_json if text.nil?
  error 400, {error: 'text too long'}.to_json if text.length > 100

  headers "Access-Control-Allow-Origin" => 'http://tadd.github.io',
    'Cache-Control' => 'public, max-age=3600'
  {translated: text.kana_to_braille}.to_json
end

DEMO_SITE = 'http://tadd.github.io/braille-ja'

get '/' do
  redirect DEMO_SITE
end
