# Seoshop::Api

This library provides a wrapper around the SEOshop REST API for use within Ruby apps or via the console.

## Installation

Add this line to your application's Gemfile:

    gem 'seoshop-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seoshop-api

## Usage

Configure:
```ruby

Seoshop.configure do |conf|
  conf.app_key = 'app_key'
  conf.secret = 'secret'
end
```

Create a client, and use it to call the SEOshop api.

```ruby

shop_api = Seoshop::Client.new('shop_token', 'shop_language')

shop_api.get_shop

shop_api.get_products

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
