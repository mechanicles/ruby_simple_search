# RubySimpleSearch

The simplest way to search the data in ActiveRecord models.

It offers simple but useful features:

- [Search on the default attributes](#search-on-the-default-attributes)
- [Override default search attributes to specific attributes ](#override-default-search-attributes-to-specific-attributes) (Credit goes to [@abdullahtariq1171](https://github.com/abdullahtariq1171))
- [Search using patterns](#search-using-patterns)
- [Ruby block support to extend the search query](#ruby-block-support-to-extend-the-search-query)
- [Simple search returns an `ActiveRecord::Relation` object](#simple-search-returns-an-activerecordrelation-object)

Mostly on the admin side, we do have a standard text field to search the data on the table.
Sometimes we want to search through the attributes like title, content and ratings on the
post model or email, username and description on the user model. For those searches, we use
MySQL's or PostgreSQL's `LIKE` operator to get the results. While doing the same thing again
and again on the different models, you add lots of duplication in your code.

#### Do not repeat yourself, use RubySimpleSearch.

[![CircleCI](https://circleci.com/gh/mechanicles/ruby_simple_search.svg?style=svg)](https://circleci.com/gh/mechanicles/ruby_simple_search)

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_simple_search'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby_simple_search

## Usage

Define attributes that you want to search on it

```Ruby
class Post < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :title, :description
end
```

```Ruby
class User < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address, :age
end
```

## Features

### Search on the default attributes
If you don't provide any attribute at the time of searching, it will use `simple_search_attributes` from the model.

```ruby
class User < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address
end


Post.simple_search('york')
# It will search in :email, :username and :address only
```

### Override default search attributes to specific attributes

If you want to perform a specific search on particular attributes, you can pass specific attributes with `attributes` option.

```ruby
class User < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address
end

Post.simple_search('york')
# It will search in :email, :username and :address only

Post.simple_search('york', attributes: :address)
# It will search in :address only

User.simple_search('york', pattern: :ending, attributes: [:email, :address])
# It will search in :email and :address only with 'ending' pattern
```

### Search using patterns
You can pass a `LIKE` pattern to the `simple_search` method. 

Patterns:

- beginning
- ending
- containing (Default pattern)
- plain

```ruby
Post.simple_search('york', pattern: :beginning)
# It will search like 'york%' and finds any values that start with "york"

Post.simple_search('york', pattern: :ending)
# It will search like '%york' and finds any values that end with "york"

Post.simple_search('york', pattern: :containing)
# It will search like '%york%' and finds any values that have "york" in any position

Post.simple_search('york', pattern: :plain)
# It will search like 'york' and finds any values that have "york" word
```

### Ruby block support to extend the search query

```Ruby
User.simple_search('35') do |search_term|
  ["AND age = ?", search_term]
end
```
Block should return an array of search condition and values.

### Simple search returns an `ActiveRecord::Relation` object

```Ruby
Model.simple_search('string') # => ActiveRecord::Relation object

Model.simple_search('string').to_sql

# OR

User.simple_search('mechanicles') do |search_term|
  ["AND address != ?", search_term]
end.to_sql

# => It will return an SQL query in string format
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
