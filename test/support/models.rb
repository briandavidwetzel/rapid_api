require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection adapter:  :sqlite3,
                                        database: 'memory'

DatabaseCleaner.strategy = :transaction

class Brick < ActiveRecord::Base
  validates_uniqueness_of :color
  before_destroy :prevent_destroy
  belongs_to :user

  def prevent_destroy
    errors.add(:base, "Destroy prevented") if color == 'prevent_destroy'
  end
end

class User < ActiveRecord::Base
  has_many :bricks
  def find_and_authenticate(params)
    where(username: params[:username], password: params[:password]).first
  end
end
