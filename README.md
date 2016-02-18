# A Grape API Adventure #
*starring Grape, Rack, and a CSV file*

This adventure consists of a simple Rack app, a Grape-based API, and a CSV database manager and record parser. It was built with Ruby 2.2.3p173 and RSpec 3.4.1. Bundler is required.

To get up and running, you'll need Bundler installed. Then, `bundle install` to get all the dependencies.

To start the app, type `bundle exec rackup`. Visit [localhost:9292](http://localhost:9292/) to see the example page. There you can see the data that currently lives in the CSV database, located at db/database.csv. A sample db is provided.

If you'd like some more data to get you started, there is a little seeder script in the repo's root that uses Faker to generate a bit of random data to sort. Make sure it's executable, then run `ruby ./seed_csv.rb` and it will create or open db/databases.csv and add 10 random records.

To run the specs, just type `bundle exec rspec`. This project uses [SimpleCov](https://github.com/colszowka/simplecov), so after you run them, you can see the coverage numbers by opening the file `coverage/index.html` from your file browser.

