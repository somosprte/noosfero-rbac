ENV['RAILS_ENV'] = (ENV['RAILS_ENV'] || 'development').dup
require "uri"
require "fileutils"
require "yaml"
require 'net/http'

dir = File.dirname(__FILE__)
SOLR_PATH = File.expand_path("#{dir}/../solr") unless defined? SOLR_PATH
config = YAML::load_file("#{Rails.root}/plugins/solr/config/solr.yml")

unless defined? RAILS_ENV
  RAILS_ENV = ENV['RAILS_ENV']
end
unless defined? SOLR_LOGS_PATH
  SOLR_LOGS_PATH = ENV["SOLR_LOGS_PATH"] || "#{Rails.root}/log"
end
unless defined? SOLR_PIDS_PATH
  SOLR_PIDS_PATH = ENV["SOLR_PIDS_PATH"] || "#{Rails.root}/tmp/pids"
end
unless defined? SOLR_DATA_PATH
  SOLR_DATA_PATH = ENV["SOLR_DATA_PATH"] || config[ENV['RAILS_ENV']]['data_path'] || "#{Rails.root}/solr/#{ENV['RAILS_ENV']}"
end
unless defined? SOLR_CONFIG_PATH
  SOLR_CONFIG_PATH = ENV["SOLR_CONFIG_PATH"] || "#{SOLR_PATH}/solr"
end
unless defined? SOLR_PID_FILE
  SOLR_PID_FILE="#{SOLR_PIDS_PATH}/solr.#{ENV['RAILS_ENV']}.pid"
end

unless defined? SOLR_PORT
  raise("No solr environment defined for RAILS_ENV = #{ENV['RAILS_ENV'].inspect}") unless config[ENV['RAILS_ENV']]

  SOLR_HOST = ENV['HOST'] || URI.parse(config[ENV['RAILS_ENV']]['url']).host
  SOLR_PORT = ENV['PORT'] || URI.parse(config[ENV['RAILS_ENV']]['url']).port
end

SOLR_JVM_OPTIONS = config[ENV['RAILS_ENV']]['jvm_options'] unless defined? SOLR_JVM_OPTIONS

if ENV["RAILS_ENV"] == 'test'
  require "active_record"
  DB = (ENV['DB'] ? ENV['DB'] : 'sqlite') unless defined?(DB)
  MYSQL_USER = (ENV['MYSQL_USER'].nil? ? 'root' : ENV['MYSQL_USER']) unless defined? MYSQL_USER
  require_relative "../test/db/connections/#{DB}/connection"
end

