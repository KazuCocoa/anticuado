# Anticuado

[![Build Status](https://travis-ci.org/KazuCocoa/anticuado.svg?branch=master)](https://travis-ci.org/KazuCocoa/anticuado)

This library collect __outdated__ libraries for each platforms. [Here](https://github.com/KazuCocoa/anticuado-example) is example how to use this library.
And [this travis project](https://travis-ci.org/KazuCocoa/anticuado-example) is just sample how to run this and the output.


## Support
- Java
    - Gradle
- iOS
    - CocoaPods
    - Carthage
- Ruby
    - Bundler
- Elixir
    - Hex
- JavaScript
    - npm

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

cocoadpos = ::Anticuado::IOS::CocoaPods.new "path/to/project"
outdated = cocoadpos.outdated 
cocoadpos.format outdated
```

#### Carthage
1. install `carthage`. Read [official document](https://github.com/Carthage/Carthage).
2. Run as the following script.

```ruby
require "anticuado"

carthage = ::Anticuado::IOS::Carthage.new "path/to/project"
outdated = carthage.outdated
carthage.format outdated
```

### Android
#### Gradle

This library require the following plugin to collect library versions.
https://github.com/ben-manes/gradle-versions-plugin

1. install `gradle` or set gradle wrapper, `gradlew`. Read [official document](https://gradle.org/).
2. Run as the following script.

```ruby
require "anticuado"

gradle = ::Anticuado::Java::Gradle.new "path/to/project" 
gradle.outdated # Writes the result to "build/dependencyUpdates" by defaylt
outdated = gradle.parse_json "build/dependencyUpdates"
gradle.format outdated
```

### Elixir
#### Hex
1. install `mix`. Read [official document](http://elixir-lang.org/install.html).
2. Run as the following script.

```ruby
require "anticuado"

hex = ::Anticuado::Elixir::Hex.new "path/to/project"
outdated = hex.outdated 
hex.format outdated
```

### Ruby
#### Bundler
1. install `bundler`. Read [official document](http://bundler.io/).
2. Run as the following script.

```ruby
require "anticuado"

bundler = ::Anticuado::Ruby::Bundler.new "path/to/project"
outdated = bundler.outdated 
bundler.format outdated
```

## In advance
- Create a PR automatically to update libraries
    - See test/anticuado/git_test.rb


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Kazu_cocoa/anticuado. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
