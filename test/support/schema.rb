ActiveRecord::Schema.define do
  connection.drop_table :bricks if connection.data_source_exists? :bricks
  connection.drop_table :users  if connection.data_source_exists? :users
  create_table :bricks do |t|
    t.string  :color
    t.decimal :weight
    t.string  :material
    t.integer :user_id
  end
  create_table :users do |t|
    t.string :username
    t.string :password
  end
end
