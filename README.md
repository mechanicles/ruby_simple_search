# RubySimpleSearch

The simplest way to search the data in ActiveRecord models.

It offers simple but useful features:

- Search on the default attributes
- Override default search attributes to specific attributes
- [Search using patterns](#patterns)
- Block support to extend the search query
- Simple search returns an `ActiveRecord::Relation`

Mostly on the admin side, we do have a standard text field to search the data on the table.
Sometimes we want to search for the title, content and ratings on the post model or email,
username and description on the user model. For those searches, we use MySQL's or PostgreSQL's
`LIKE` operator to get the results. While doing the same thing again and again on the different
models, you add lots of duplication in your code.

#### Do not repeat yourself, use RubySimpleSearch.

[![CircleCI](https://circleci.com/gh/mechanicles/ruby_simple_search.svg?style=svg)](https://circleci.com/gh/mechanicles/ruby_simple_search)

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_simple_search'

And then execute:

    $ bundle

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

  simple_search_attributes :email, :username, :address
end
```

Please do not pass **integer/decimal** data type attributes to the `simple_search_attributes `
method, instead; you can handle these types by passing block to the `simple_search` method.
Block should return an array of search condition and values.

## Features

<a name="patterns"> 1 </a> - You can pass a `LIKE` pattern to the `simple_search` method

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

2 - Overide default search attributes (Credit goes to [@abdullahtariq1171](https://github.com/abdullahtariq1171))

```ruby
Post.simple_search('york', pattern: :beginning, attributes: :name)

User.simple_search('york', pattern: :ending, attributes: [:name, :address])
```

3 - Ruby block support to extend the query

```Ruby
User.simple_search('35') do |search_term|
  ["AND age = ?", search_term]
end
```

4 - Search returns `ActiveRecord::Relation` Object


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
