# ArPagination

Active Record Pagination is a gem that allows simple pagination for your api's resource endpoint responses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ar_pagination'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar_pagination

## Usage

### Cursor Pagination

The cursor is the value of an attribute you would like to fetch a number of resources before/after.

Add the following to your controller:

Query params:

```
def query_params
  validate_range!(:count, 1..100)
  query_params = params.permit(:cursor, :count, :sort) #sort is like: "+age,-name" to sort first by age ascending and name descending
  query_params
end
```

Include the concern:

```
class SomeController < ActionController::Base
include ArPagination::RespondWithPage
```

Use for the response

```
def index
  ...
  @page = ArPagination::CursorPagination::Query.new(@resource_scope).fetch(query_params)

  respond_with_page @page
end
```

### Offset Pagination

The offset specifies the number of resources to fetch the count number of resources after.

Add the query params to your controller:

```
def query_params
  validate_range!(:count, 1...100)
  query_params = params.permit(:count, :offset, :sort)
  query_params
end
```

Use in your endpoint method, similar to:

```
def index
  ...
  respond_with_page @page = OffsetPagination::Page.new(@resource_scope, query_params)
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ar_pagination/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
