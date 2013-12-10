# RubySimpleSearch

RubySimpleSearch allows you to search on the table fields (string and text fields)
very easily.

Mostly on admin side, we do have a common search text field to search the table
columns data.

Sometimes we want to do search on the title, content and ratings on the post model or
email, username and description on the user model. For those searches we use MySQL's
or PostgreSQL's LIKE operator to get the results. While doing same thing again and again
on the different models you actually add lots of duplications in your code.

To avoid duplicating the same code, use RubySimpleSearch :)

#### RubySimpleSearch Features:
- Added like pattern support ('beginning', 'ending', 'containing', 'underscore', 'plain').
  By default pattern is 'containing'

```Ruby
    simple_search_attributes :name, :address, :pattern => :ending
    # It will search like '%york'

    simple_search_attributes :name, :address, :pattern => :begining
    # It will search like 'york%'

    simple_search_attributes :name, :address, :pattern => :containing
    # It will search like '%york%'

    simple_search_attributes :name, :address, :pattern => :underscore
    # It will search like '_o_'

    simple_search_attributes :name, :address, :pattern => :plain
    # It will search like 'york'
```
- Added **block** support to simple_search method, so user can extend the query as per
  his/her requirements (Now you can operate on the integer/decimal values also)

- Added specs

- Added exception handler

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_simple_search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_simple_search

## Usage

Define attributes that you want to search through RubySimpleSearch

```Ruby
class Post < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :title, :description, :pattern => :begining
end

class User < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address
end

# While defining simple_search_attributes, don't add integer/decimal data
# attributes to it. It will give an error, instead of this you can do
# integer/decimal operation by passing block to simple search method

Post.simple_search('tuto')
# => posts which have 'tuto%' text in the title or in the description fields

User.simple_search('mechanicles')
# => users which have 'mechanicles' text in the email, username and in address

User.simple_search('mechanicles') do |search_term|
  ["and address != ?", search_term]
end

# => You can pass block to simple_search method so you can extend it as your
# wish but you need to return an array of valid parameters like you do in #where
# method

Model.simple_search('string')
# => with and without block will return ActiveRecord::Relation object

Model.simple_search('string').to_sql

#OR

User.simple_search('mechanicles') do |search_term|
  ["and address != ?", search_term]
end.to_sql

# => will return sql query in string format
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
