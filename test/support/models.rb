require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection adapter:  :sqlite3,
                                        database: 'memory'

DatabaseCleaner.strategy = :transaction

Brick = Class.new(ActiveRecord::Base)

class User < ActiveRecord::Base

  def find_and_authenticate(params)
    where(username: params[:username], password: params[:password]).first
  end
end
