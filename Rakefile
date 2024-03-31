# Load the environment
require_relative 'config/environment'

namespace :db do
  desc 'Create database'
  task :create do
    begin
      ActiveRecord::Base.connection
      puts "Database '#{db_config['development']['database']}' already exists"
    rescue ActiveRecord::NoDatabaseError
      begin
        ActiveRecord::Tasks::DatabaseTasks.create(db_config['development'])
        puts "Database '#{db_config['development']['database']}' created successfully"
      rescue ActiveRecord::Tasks::DatabaseAlreadyExists
        puts "Database '#{db_config['development']['database']}' already exists"
      end
    end
  end

  desc 'Migrate database'
  task :migrate do
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end

  desc 'Rollback last migration'
  task :rollback do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.rollback('db/migrate')
  end

  desc 'Create migration'
  task :create_migration do
    name = ENV['name'] || 'migration'
    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    migration_file = "db/migrate/#{timestamp}_#{name}.rb"
    template = <<-TEMPLATE
      class #{name.camelize} < ActiveRecord::Migration[6.1]
        def change
          # Add your migration code here
        end
      end
    TEMPLATE

    File.write(migration_file, template)
    puts "Created migration file: #{migration_file}"
  end

  desc 'Seed database'
  task :seed do
    load 'db/seeds.rb'
  end

end

