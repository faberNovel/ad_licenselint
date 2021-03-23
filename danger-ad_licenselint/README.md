# Danger ad_licenselint

A [Danger Ruby](https://github.com/danger/danger) plugin for [ad_licenselint](https://github.com/faberNovel/ad_licenselint/)

## Installation

```
gem install danger-ad_licenselint
```

## Usage

The easiest way to use is just add this line to your Dangerfile:

```ruby
ad_licenselint.lint_licenses
```

By default, `danger-ad_licenselint` will add a comment to your PR for pods that are modified (added or updated).

If you want to post inline comments for modified pods, run

```ruby
ad_licenselint.lint_licenses inline_mode: true
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
