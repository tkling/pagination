# Pagination!

## Setup
* This app uses `sqlite3` as the backing db
  * install on OSX with `brew install mysql3`
* Run the following steps in your terminal to get up and running:
```bash
# if you don't have ruby 2.5.1 yet
rbenv install

# pull down required gems
bundle install

# setup and seed the database
bundle exec rake db:setup
``` 

## Running Tests
```bash
bundle exec ruby app_test.rb
```

## Launching the application
```bash
# the app responds to port 4567
bundle exec ruby app.rb
```
