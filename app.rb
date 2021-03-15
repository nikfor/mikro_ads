require 'sinatra'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'dry-initializer'
require 'fast_jsonapi'
require 'sinatra/url_for'
require 'kaminari'

APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__)))
Dir.glob("#{APP_ROOT}/{models,serializers,services,helpers}/**/*.rb").each(&method(:require))

include PaginationLinks

get '/' do
  ads = Ad.order(updated_at: :desc).page(params[:page])
  serializer = AdSerializer.new(ads, links: pagination_links(ads))

  json serializer.serialized_json
end

post '/ads' do
  puts request.params
  result = Ads::CreateService.call(ad_params)

  if result.success?
    serializer = AdSerializer.new(result.ad)
    status :created
    json serializer.serialized_json
  else
    error_response(result.ad, :unprocessable_entity)
  end
end

private

def ad_params
  return {} if params[:ad].nil?

  { ad: params[:ad].slice('title', 'description', 'city', 'user_id') }
end

def error_response(error_messages, status_code)
  errors = case error_messages
  when ActiveRecord::Base
    ErrorSerializer.from_model(error_messages)
  else
    ErrorSerializer.from_messages(error_messages)
  end

  status status_code
  json errors
end