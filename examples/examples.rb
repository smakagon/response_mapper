require 'response_mapper'
require 'dry-struct'

# With basic Hash:
response = { "foo" => "bar" }
ResponseMapper.map(data: response, mapping: { foo: :name })
# { name: "bar" }

# With Array of strings:
response = ["order_number", "order_items"]
ResponseMapper.map(data: response, mapping: { "order_number" => "id" })
# ["id", "order_items"]

# With Array of Hashes it still symbolizes and maps all keys:
response = [
  { "order_number" => 1, "order_items" => [{"order_id" => 11, "title" => "Foo" }] },
  { "order_number" => 2, "order_items" => [{"order_id" => 21, "title" => "Bar" }] },
]

mapping = { order_number: :id, order_items: :items, order_id: :id }
ResponseMapper.map(data: response, mapping: mapping)
# [
#   { id: 1, items: [{ id: 11, title: "Foo" }]},
#   { id: 2, items: [{ id: 21, title: "Bar" }]}
# ]


# Dry-Struct Example
module Types
  include Dry::Types.module
end

class Order < Dry::Struct::Value
  attribute :id, Types::Strict::Int
  attribute :amount, Types::Strict::Int
end

response = { "order_number" => 1, "total_amount" => 200 }
mapping = { order_number: :id, total_amount: :amount }

order_attributes = ResponseMapper.map(data: response, mapping: mapping)

order = Order.new(order_attributes)
order.id # => 1
order.amount # => 200
