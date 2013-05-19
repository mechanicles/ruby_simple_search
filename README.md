# RubySimpleSearch

RubySimpleSearch allows to search on the table fields. 
e.g. string and text fields.

Sometimes we want to do search on the post's title and content
or user's email, username and description or on other models but in same way.
For those searches we use MySql's or PostgreSQL's LIKE operator to get the
results. While doing same thing on the different models you actually add lots of 
duplications in your code.

To avoid duplicating the same code, use RubySimpleSearch :)

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

  simple_search_attributes :title, :description
end

class User < < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address
end

Post.simple_serach('tutorial')
# => posts which have 'tutorial' text in title or in description fields

User.simple_search('Mechanicles')
# => users which have 'Mechanicles' text in the email, username and in address

Model.simple_search('string')
# => will return ActiveRecord::Relation object
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
