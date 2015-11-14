# rAPId [![Code Climate](https://codeclimate.com/github/briandavidwetzel/rapid_api/badges/gpa.svg)](https://codeclimate.com/github/briandavidwetzel/rapid_api) [![Build Status](https://travis-ci.org/briandavidwetzel/rapid_api.svg)](https://travis-ci.org/briandavidwetzel/rapid_api) [![Test Coverage](https://codeclimate.com/github/briandavidwetzel/rapid_api/badges/coverage.svg)](https://codeclimate.com/github/briandavidwetzel/rapid_api/coverage)

A framework for rapid development of Rails APIs.

## Installation
Include in your Gemfile:

```ruby
gem 'rapid_api', git: 'git://github.com/briandavidwetzel/rapid_api.git'
```

## Documentation
### Rapid Actions
```ruby
class BricksController < ApplicationController
  rapid_actions

  permit_params :color, :weight, :material
end
```
