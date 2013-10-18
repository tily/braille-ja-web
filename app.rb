require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'braille-ja'
require 'digest'
require 'dalli'

configure do
  if memcachier_servers = ENV["MEMCACHIER_SERVERS"]
    set :cache, Dalli::Client.new(memcachier_servers,
                                  username: ENV["MEMCACHIER_USERNAME"],
                                  password: ENV["MEMCACHIER_PASSWORD"])
  end
end

helpers do 
  def setup_cache(seed)
    cache_control :public, max_age: 3600
    etag Digest::SHA1.hexdigest(seed)
  end
end

get '/translate' do
  content_type :json
  text = params[:text]
  error 400, {error: 'text required'}.to_json if text.nil?
  error 400, {error: 'text too long'}.to_json if text.length > 100

  headers "Access-Control-Allow-Origin" => 'http://tadd.github.io'
  setup_cache(text)
  {translated: text.kana_to_braille}.to_json
end

DEMO_SITE = 'http://tadd.github.io/braille-ja'

get '/' do
  redirect DEMO_SITE
end
