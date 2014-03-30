# RubySimpleSearch

RubySimpleSearch allows you to search on the table fields (string and text fields)
very easily.

Mostly on the admin side, we do have a common text field to search the data on the
table.

Sometimes we want to do a search on the title, content and ratings on the post model or
email, username and description on the user model. For those searches we use MySQL's
or PostgreSQL's LIKE operator to get the results. While doing the same thing again and again
on the different models you actually add lots of duplication in your code.

To avoid duplicating the same code, use RubySimpleSearch :)

#### Version 0.0.3 changes:
- 'LIKE' pattern is more flexible now. Now you can pass pattern on ```simple_search```
  method directly. Pattern support on the ```simple_search_attributes``` method has been removed
- Fixed column ambiguous error when used with the joins


#### RubySimpleSearch Features:
- Added 'LIKE' pattern support ('beginning', 'ending', 'containing', 'underscore', 'plain').
  By default pattern is 'containing'

```Ruby
    Post.simple_search('york', :pattern => :ending)
    # It will search like '%york'

    Post.simple_search('york', :pattern => :begining)
    # It will search like 'york%'

    Post.simple_search('york', :pattern => :containing)
    # It will search like '%york%'

    Post.simple_search('o', :pattern => :underscore)
    # It will search like '_o_'

    Post.simple_search('yourk', :pattern => :plain)
    # It will search like 'york'
```
- Added **block** support to ```simple_search``` method, so user can extend the query as per
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

  simple_search_attributes :title, :description
end
```
```Ruby
class User < ActiveActiveRecord::Base
  include RubySimpleSearch

  simple_search_attributes :email, :username, :address
end
```
While defining ```simple_search_attributes```, don't add integer/decimal data
attributes to it, instead of this you can do integer/decimal operation
by passing block to ```simple_search``` method
```Ruby
Post.simple_search('tuto', :pattern => :begining)
# => posts which have 'tuto%' text in the title or in the description fields
```
```Ruby
User.simple_search('mechanicles')
# => users which have 'mechanicles' text in the email, username and in address
```
```Ruby
User.simple_search('mechanicles') do |search_term|
  ["and address != ?", search_term]
end
# => You can pass block to simple_search method so you can extend it as your
# wish but you need to return an array of valid parameters like you do in #where
# method
```
```Ruby
Model.simple_search('string')
# => with and without block will return ActiveRecord::Relation object
```
```Ruby
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
