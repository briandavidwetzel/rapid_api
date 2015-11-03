require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection adapter:  :sqlite3,
                                        database: 'memory'

DatabaseCleaner.strategy = :transaction

Brick = Class.new(ActiveRecord::Base)
User  = Class.new(ActiveRecord::Base)
