$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# Use the test database if we're testing, use the regular db if we're running the app
if ENV['RACK_ENV'] == 'test'
  ENV['DB_PATH'] = "test.csv"
else
  ENV['DB_PATH'] = "database.csv"
end

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

require 'rspec'
require 'grape'
require 'json'
require 'csv'
require 'reverb_records'
require 'record_parser'
require 'api'