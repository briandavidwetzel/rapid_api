ActiveRecord::Schema.define do
  create_table :bricks do |t|
    t.string  :color
    t.decimal :weight
    t.string  :material
  end
end
