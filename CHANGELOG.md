# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## 2.0.1
- Supported Rails 6
- Dropped support Rails < 5

## 2.0.0
### Added
- Supports `attributes` parameter to `simple_search` method. [PR#4](https://github.com/mechanicles/ruby_simple_search/pull/4)
- Supports data types other than `string` and `text` to `simple_search_attributes`
- Now tests cover **SQLite**, **MySQL**, and **PostgreSQL** databases

### Changed
- Used Minitest over RSpec
- Refactored the code
- Used Travis CI over CircleCi

### Removed
- Removed `plain` pattern from `LIKE` query

## 0.0.3
### Fixed
- Fixed problem when using simple search with joins. [GI#1](https://github.com/mechanicles/ruby_simple_search/issues/1)

### Changed
- Moved pattern option to `simple_search` method and removed it from `simple_search_attributes` method
- Updated specs accordingly

## 0.0.2
### Added
- Added support for `LIKE` patterns e.g. 'beginning', 'ending', 'containing', 'underscore', and 'plain'
- Added block support to `simple_search` method so user can extend it based on its need
- Added specs
- Added some exceptions handling

## 0.0.1
### Added
- First major release
