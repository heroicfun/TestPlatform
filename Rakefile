require 'pg'
require 'active_record'
require 'yaml'

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    db_connection = YAML::load(File.open('config.yml'))['development']['db_connection']
    ActiveRecord::Base.establish_connection(db_connection)
    ActiveRecord::Migration.migrate('db/migrate/')
  end

  desc 'Create the database'
  task :create do
    db_connection = YAML::load(File.open('config.yml'))['development']['db_connection']
    admin_connection = db_connection.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(db_connection.fetch('database'))
  end

  desc 'Drop the database'
  task :drop do
    db_connection = YAML::load(File.open('config.yml'))['development']['db_connection']
    admin_connection = db_connection.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(db_connection.fetch('database'))
  end
end