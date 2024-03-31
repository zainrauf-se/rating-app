# config/environment.rb

require 'rack'
require 'json'
require 'yaml'
require 'active_record'
require 'faker'

# Load database configuration from config/database.yml
db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config['development'])

# Load all models
Dir['./app/models/*.rb'].each { |file| require file }
