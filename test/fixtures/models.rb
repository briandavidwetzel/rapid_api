require 'active_record'
ActiveRecord::Base.establish_connection adapter: :nulldb, schema: 'schema.rb'

NullDB.configure do |config|
  config.project_root = './test/fixtures'
end

Brick = Class.new(ActiveRecord::Base)
