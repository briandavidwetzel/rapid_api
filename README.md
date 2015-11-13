# rAPId
[![Code Climate](https://codeclimate.com/github/briandavidwetzel/rapid_api/badges/gpa.svg)](https://codeclimate.com/github/briandavidwetzel/rapid_api)

---

A framework for rapid development of Rails APIs.

---
## Installation
Include in your Gemfile:

`gem 'rapid_api', git: 'git://github.com/briandavidwetzel/rapid_api.git'`

## Documentation
### Rapid Actions
```ruby
class BricksController < ApplicationController
  rapid_actions

  permit_params :color, :weight, :material
end
```
