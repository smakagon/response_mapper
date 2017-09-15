[![Build Status](https://travis-ci.org/smakagon/response_mapper.svg?branch=master)](https://travis-ci.org/smakagon/response_mapper)

# ResponseMapper

These days we all deal with many different APIs.
It can be either third-party services, or our own microservices.
Not all of them are well-designed and sometimes their attributes named in a really weird way.

`ResponseMapper` allows to map weird attributes from API response to your domain language.

For example:

```ruby
response = JSON.parse(response_from_api)
# {
#   "order_number" => 10,
#   "order_items" => [{ order_item_id: 1, item_title: "Book" }]
# }
```

Once we parsed response, all keys are strings. Usually we want to do two things:

1. Map response, so we can easily instantiate entity from response.
2. Symbolize keys to keep things consistent.

With `ResponseMapper` we can do this:

```ruby
mapping = { order_number: :id, order_item_id: id,  order_items: :items, item_title: :title }
order = ResponseMapper.map(data: response, mapping: mapping)
# {
#   id: 10,
#   items: [{ id: 1, title: "Book" }]
# }
```

Now we have nice Hash with symbolized keys that correspond to attributes of `Order` in our system.
For example further step could be just wrap this hash into Order entity:

```ruby
Entity::Order.new(order)
```

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

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smakagon/response_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
