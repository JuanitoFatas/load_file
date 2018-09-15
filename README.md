# LoadFile

Load/Overload YAML/JSON file(s) into desired constant.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "load_file"
```

## Usage

```ruby
LoadFile.load(file: "examples/.travis.yml", constant: :TravisConfig)

# now you can access TravisConfig for configs in examples/.travis.yml
TravisConfig
=> {"sudo"=>false, "language"=>"ruby", "cache"=>"bundler", "rvm"=>["2.5.1"]}

LoadFile.load(file: "examples/app.json", constant: :HerokuApp)

# now you can access HerokuApp for configs in examples/app.json
HerokuApp
=> {"name"=>"Small Sharp Tool",
  ...
  "environments"=>{"test"=>{"scripts"=>{"test"=>"bundle exec rake test"}}}}
```

### What if I want to override existing constant?

Use `overload` APIs.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JuanitoFatas/devyml.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
