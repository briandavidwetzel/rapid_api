# rAPId [![Code Climate](https://codeclimate.com/github/briandavidwetzel/rapid_api/badges/gpa.svg)](https://codeclimate.com/github/briandavidwetzel/rapid_api) [![Build Status](https://travis-ci.org/briandavidwetzel/rapid_api.svg)](https://travis-ci.org/briandavidwetzel/rapid_api) [![Test Coverage](https://codeclimate.com/github/briandavidwetzel/rapid_api/badges/coverage.svg)](https://codeclimate.com/github/briandavidwetzel/rapid_api/coverage)

*NOT PRODUCTION READY*

__A framework for rapid development of Rails APIs__-- *RapidApi* aims to reduce code maintenance and testing costs, while increasing speed of development. Because the ceremony of rendering REST actions is performed for you, you can focus more time on what makes your app unique.

## Installation
Include in your Gemfile:

```ruby
gem 'rapid_api', git: 'git://github.com/briandavidwetzel/rapid_api.git'
```

## Documentation
### Rapid Actions
Including `rapid_actions` in your controller will give you conventional RESTful actions: `#index, #show, #create, #update, and #destroy`.
```ruby
class BricksController < ApplicationController
  rapid_actions

  permit_params     :color, :weight, :material
  filterable_params :color
end
```
#### Permitted Params
The `permit_params` macro secures member requests using strong params.  Just pass the attributes that you want to be used in creation or update of your model.

#### Filterable Params
The `filterable_params` macro is similar `permit_params`, except that it applies to the collection instead of the member. RapidApi supports basic filtering on the index action.  A hash of keys and values will be passed to the model adapter secured via strong params.

#### Error Handling
Error handling is provided automatically for the generated actions. There are currently three potential errors that can be raised and are rendered:
* __NotFoundError__ (`:not_found`) - obviously, when a member is not found to be shown, updated, or destroyed.
* __NotProcessableError__ (`:unprocessable_entity`) - this will be rendered when a member has errors added during the create or update process.
  * *NOTE: For ActiveRecord, this pattern emphasizes using errors.add over raising exceptions.  Also, for AMS, this convention works well with Ember Data's ActiveModelAdapter errors object out of the box.*
* __StandardError__ (`:internal_server_error`) - Everything else gets caught as an internal server error. The error message is serialized in the json response body.

#### Configuration
By default, RapidApi will attempt to use ActiveRecord, ActiveModelSerializer and the Rails naming conventions to discover your model and serializer per controller, but you are able to customize the definition. You can pass optional arguments to the `rapid_actions` macro as follows.
```ruby
rapid_actions model: YourModel, serializer: YourSerializer, model_adapter: CustomModelAdapter, serializer_adapter: CustomSerializerAdapter
```
These settings could also be set globally using the configuration object. For example,
```ruby
RapidApi.config.model_adapter      = CustomModelAdapter
RapidApi.config.serializer_adapter = CustomSerializerAdapter
```
You can also override the response codes, if necessary.
```ruby
RapidApi.config.response_codes[:created] = :ok
```

### Scoping
If you want to scope your controller by a given attribute or attributes, you can use the `scope_by` macro
```ruby
class BricksController < ApplicationController
  rapid_actions

  permit_params     :color, :weight, :material
  filterable_params :color

  scope_by :user_id do |controller|
    controller.authenticated.id
  end
end
```
The scope by block should return the corresponding value for the attribute(s), passed to `scope_by`. In the event that there are multiple scoping attributes, you should return an array of values in the block. The scope will apply to all generated actions.

### Authentication
*NOTE: The authentication functionality is likely to be moved to another gem by the release of v1*

Some basic API appropriate authentication is available in the form [json web tokens](http://jwt.io). However, you can use RapidApi without taking advantage of this functionality.

#### The Sessions Controller
```ruby
class SessionsController < ApplicationController
  rapid_sessions_controller

  authenticates_with :username, :password do |params|
    User.where(username: params[:username], password: params[:password]).first
  end

  responds_with do |authenticated|
    {
      token: jwt_encode({ secret: 'foo' }),
      user: {
        id:       authenticated.id,
        username: authenticated.username
      }
    }
  end
end
```

`rapid_sessions_controller` will generate an authenticate method, that can be called to initiate a session with your api. The `authenticates_with` macro accepts the parameters that will be used to authenticate, and a block that will do the actual authentication. The block should return the authenticated object. *In the example given, the authenticated User.* Returning nil, well render an `:unauthorized` response. Otherwise, `responds_with` is passed the authenticated object to build the auth token payload for the authentication response.

#### Authenticated Controllers
```ruby
class ApplicationController
  rapid_base_controller

  authenticate do |controller|
    token = controller.decode_jwt_token!(controller.request.headers.env['Authorization'])
    user_id = token[0].try :[], 'user_id'
    if user_id.present?
      User.find user_id
    else
      nil
    end
  end
end
```
`rapid_base_controller` can be added to the base class for your api controllers to provide a before_filter that checks authentication. Note if your SessionController is derived from the same base class, then you should add `skip_before_filter :authenticate!` to your SessionsController.  The `authenticate` macro should be passed a block that returns the authenticated object. *In the example, the 'Authorization' token is parsed to return the current user*. If your authenticate block returns nil, then `:unauthorized` will be rendered.

Also note that the `decode_jwt_token!` can raise errors that will result in the rendering of an `:unauthorized` response.

### Extending RapidApi
If you don't want to use ActiveRecord or ActiveModelSerializer, that is OK. You can create your own adapters.

There are two abstract classes that can be used as base classes for your own implementation: `RapidApi::ModelAdapters::Abstract` and `RapidApi::SerializerAdapters::Abstract`. See the implemented adapters and tests for examples on how to implement an adapter.  Post an issue if you get stuck.
