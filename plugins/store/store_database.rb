require 'active_record'

module Automatic::Plugin
  module StoreDatabase
    def for_each_new_feed
      prepare_database
      existing_records = model_class.find(:all)
      return_feeds = []
      @pipeline.each { |feeds|
        unless feeds.nil?
          new_feed = false
          feeds.items.each { |feed|
            unless existing_records.detect { |b| b.try(unique_key) == feed.link }
              yield(feed)
              new_feed = true
            end
          }
          return_feeds << feeds if new_feed
        end
      }
      return_feeds
    end

    private

    def create_table
      ActiveRecord::Migration.create_table(model_class.table_name) do |t|
        column_definition.each_pair do |column_name, column_type|
          t.column column_name, column_type
        end
      end
    end

    def db_dir
      return File.join(File.dirname(__FILE__), '..', '..', 'db')
    end

    def prepare_database
      ActiveRecord::Base.establish_connection(
        :adapter  => "sqlite3",
        :database => File.join(db_dir, @config['db']))
      create_table unless model_class.table_exists?
    end
  end
end
  
