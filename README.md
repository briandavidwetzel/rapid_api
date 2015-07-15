# rAPId
A framework for rapid development of Rails APIs.

```ruby
class BricksController < ApplicationController
  rapid_actions
  
  permit_params :color, :weight, :material
end
```

## Installation
Include in your Gemfile:

`gem 'rapid_api', git: 'git://github.com/briandavidwetzel/rapid_api.git'`
