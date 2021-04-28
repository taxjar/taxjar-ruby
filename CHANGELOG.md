# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Support request logging

## [3.0.2] - 2021-03-18
- Re-classify `HTTP::ConnectionError` and other `HTTP::Error` types as `Taxjar::Error`

## [3.0.1] - 2021-03-16
- Throw a `Taxjar::Error` exception for any non-successful HTTP response

## [3.0.0] - 2020-04-03
- Add information to custom user agent for debugging and informational purposes
- Update required Ruby version from 2.0 to 2.3 or higher
- Update HTTP (The Gem) to version 4.3
- Relax bundler (development dependency) version requirements

## [2.6.1] - 2019-10-23
- Parse all responses as JSON and improve error handling for non-JSON [#51](https://github.com/taxjar/taxjar-ruby/pull/51)

## [2.6.0] - 2019-07-09
- Support `exemption_type` param for order-level exempt transactions

## [2.5.0] - 2019-06-19
- Support `provider` param for marketplace exempt transactions
- Add proxy support when instantiating client

## [2.4.1] - 2019-02-04
- Relax HTTP.rb gem version requirements
- Add RubyGems metadata

## [2.4.0] - 2018-10-31
- Address validation for TaxJar Plus customers

## [2.3.0] - 2018-09-17
- Provide access to new jurisdiction names via `tax_for_order`

## [2.2.0] - 2018-05-02
- Support customer exemptions

## [2.1.0] - 2018-03-21
- Sandbox environment support with `api_url` and custom headers

## [2.0.0] - 2017-10-30
- Update minimum required Ruby version to 2.0
- Update HTTP (The Gem) to 2.2

[Unreleased]: https://github.com/taxjar/taxjar-ruby/compare/v3.0.2...HEAD
[3.0.2]: https://github.com/taxjar/taxjar-ruby/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/taxjar/taxjar-ruby/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.6.1...v3.0.0
[2.6.1]: https://github.com/taxjar/taxjar-ruby/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.4.1...v2.5.0
[2.4.1]: https://github.com/taxjar/taxjar-ruby/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/taxjar/taxjar-ruby/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/taxjar/taxjar-ruby/compare/v1.7.1...v2.0.0
