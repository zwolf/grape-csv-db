# Reverb Records #

Reverb Records is a simple Rack app, Grape-based API, and CSV database manager. 

To get up and running, you'll need Bundler installed. Then, `bundle install` to get all the dependencies.

To start the app, type `rackup`. Visit [localhost:9292](http://localhost:9292/) to see the example page. 
There you can see the data that currently lives in the CSV database, located at db/database.csv.

If you'd like some data to get you started, there is a litle seeder script in the repo's root that uses Faker to generate a bit of random data to sort. Make sure it's executable, then run `ruby ./seed_csv.rb` and it will create or open db/databases.csv and add 10 random records.

To run the specs, just type `rspec`. This project uses [SimpleCov](https://github.com/colszowka/simplecov), so after you run them, you can see the coverage numbers by opening this file: `coverage/index.html`

