#Glympse

An application to share user locations

==========================================

Techonologies Used:
- Ruby on Rails
- Mysql (couldn't setp up Postgres for debian broken packages)
- Google maps


Prequsites
------------
- Some browser with sane es6 support (for `let`, `template strings`)

Before continuing modify the `config/database.yml` and `config/initializers/geocodes.rb`


Starting the application

```
bundle install
rake db:setup
rails s
```
