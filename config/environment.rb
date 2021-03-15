require 'bundler'
# require 'logger'
# require 'securerandom'
# require 'yaml'

Bundler.require


APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../'))
APP_ENV ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

# requires
# Dir.glob("#{APP_ROOT}/{lib,models}/**/*.rb").each(&method(:require))
