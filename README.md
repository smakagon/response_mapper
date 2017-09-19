[![Build Status](https://travis-ci.org/smakagon/response_mapper.svg?branch=master)](https://travis-ci.org/smakagon/response_mapper)

# ResponseMapper
These days we all deal with many different APIs; It can be either third-party services, or our own microservices. Not all of them are well-designed and sometimes their attributes are named inconsistently.

`ResponseMapper` allows you to map attributes from an API response to your application’s domain language.

### An example of a common API response before ResponseMapper:
```ruby
{ "orderNumber" => 10, "orderItems" => [{ "orderItemId" 1, "itemTitle" "Book" }] }
```

### An example of the above API response after  `ResponseMapper`
```ruby
{ id: 10, items: [{ id: 1, title: "Book" }] }
```

## What does `ResponseMapper` Do?
Using the example above let’s look at a response we may get from a 3rd party API:
```ruby
response = JSON.parse(response_from_api)
# => { "orderNumber" => 10, "orderItems" => [{ "orderItemId" 1, "itemTitle" "Book" }] }
```

### Once we parsed response, all keys are strings. Usually we want to do two things:
1. Map response, so we can easily instantiate entity from response.
2. Symbolize keys to keep things consistent.

### With `ResponseMapper` we can do this:

```ruby
mapping = { orderNumber: :id, orderItems: :items, orderItemId: :id, itemTitle: :title }

order_attributes = ResponseMapper.map(data: response, mapping: mapping)
# => { id: 10, items: [{ id: 1, title: "Book" }] }
```

Now we have a nice Hash with symbolized keys that correspond to attributes of `Order` in our system.
For example further step could be just wrap this hash into `Order` entity:

```ruby
Entity::Order.new(order_attributes)
```

`ResponseMapper` maps and symbolizes keys even for nested arrays and hashes.
It will work for more complex responses.

See [more examples here](https://github.com/smakagon/response_mapper/blob/master/examples/examples.rb).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'response_mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install response_mapper

## Usage
`ResponseMapper` provides one class method `.map` which has two required params: `data` and `mapping`.
There is one optional parameter: `symbolize_keys` which is set to `true` by default.

ex.
```ruby
order_attributes = ResponseMapper.map(data: response, mapping: mapping)
```

### `data`
`data` can be anything, but `ResponseMapper` will try to map it only if it's a `Hash` or `Array`.
If it's not a `Hash` or `Array` - `ResponseMapper` will return `data` as is.

### `mapping`
`mapping` should be a Hash with attributes you want to map:

```ruby
mapping = { orderNumber: :id, orderItems: :items, orderItemId: :id, itemTitle: :title }
```

It will map any occurrence of `:order_number` in data to `:id`.
If `mapping` is not a Hash (or empty Hash) - ResponseMapper will raise `ResponseMapper::Error`.

### `symbolize_keys`
`sybmolize_keys` is set to `true` by default.
If your data contains hashes with strings as keys, they will be symbolized and then mapped.

See [more examples here](https://github.com/smakagon/response_mapper/blob/master/examples/examples.rb).

Read [article](http://rubyblog.pro/2017/09/how-to-protect-naming-conventions-when-working-with-microservices) on how `ResponseMapper` can help to protect naming conventions when working with microservices or third-party API.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smakagon/response_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
