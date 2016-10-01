# Anticuado

This library collect output

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'anticuado'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anticuado

## Usage

This library's results are like the following format:

```ruby
[
  { 
    library_name: "AFNetworking",
    current_version: "2.5.0",
    available_version: "3.1.0",
    latest_version: "3.1.0"
  },
  { 
    library_name: "OHHTTPStubs",
    current_version: "4.1.0",
    available_version: "5.0.0",
    latest_version: "5.0.0"
  }
]
```

### iOS
#### CocoaPods
1. install `cocoadpos`. Read [official document](https://cocoapods.org/).
2. Run as the following script.

```ruby
require "anticuado"

outdated = ::Anticuado::IOS::CocoaPods.outdated project: "path/to/project"
::Anticuado::IOS::CocoaPods.format outdated
```

#### Carthage
1. install `carthage`. Read [official document](https://github.com/Carthage/Carthage).
2. Run as the following script.

```ruby
require "anticuado"

outdated = ::Anticuado::IOS::Carthage.outdated project: "path/to/project"
::Anticuado::IOS::Carthage.format outdated
```

### Android
#### Gradle

This library require the following plugin to collect library versions.
https://github.com/ben-manes/gradle-versions-plugin

1. install `gradle` or set gradle wrapper, `gradlew`. Read [official document](https://gradle.org/).
2. Run as the following script.

```ruby
require "anticuado"

::Anticuado::Java::Gradle.outdated project: "path/to/project"
outdated = ::Anticuado::Java::Gradle.parse_json "build/dependencyUpdates"
::Anticuado::Java::Gradle.format outdated
```

### Elixir
#### Hex
1. install `mix`. Read [official document](http://elixir-lang.org/install.html).
2. Run as the following script.

```ruby
require "anticuado"

outdated = ::Anticuado::Elixir::Hex.outdated project: "path/to/project"
::Anticuado::Elixir::Hex.format outdated
```

### Ruby
#### Bundler
1. install `bundler`. Read [official document](http://bundler.io/).
2. Run as the following script.

```ruby
require "anticuado"

outdated = ::Anticuado::Ruby::Bundler.outdated project: "path/to/project"
::Anticuado::Ruby::Bundler.format outdated
```

## In advance


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/anticuado. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

