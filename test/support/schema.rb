ActiveRecord::Schema.define do
  connection.drop_table :bricks if connection.table_exists? :bricks
  create_table :bricks do |t|
    t.string  :color
    t.decimal :weight
    t.string  :material
  end
end
