# -*- coding: utf-8 -*-
ENV['RACK_ENV'] = 'test'

require_relative '../app'

require 'rspec/core'
require 'rack/test'
require 'json'

describe 'Braille-ja Web' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'API' do
    it "translates" do
      get '/translate', text: 'あ'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)['translated']).to eq '⠁'
    end

    it "returns client error if text is too long" do
      TOO_LONG = 10000
      get '/translate', text: 'あ' * TOO_LONG
      expect(last_response).to be_client_error
      expect(JSON.parse(last_response.body)['error']).to match /too long/
    end

    it "returns client error unless text specified" do
      get '/translate' # without params
      expect(last_response).to be_client_error
      expect(JSON.parse(last_response.body)['error']).to match /required/
    end

    it 'pings' do
      get '/ping'
      expect(last_response).to be_ok
      expect(last_response.body).to eq 'pong'
    end
  end
end
