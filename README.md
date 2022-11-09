# README

* Run `bundle install`
* Create at the root of project the following file `.ruby-env`. In there add `PORT=5000`
* From terminal, exit from project folder an get in again ( to update env variables )
* Run `rails db:migrate`
* I am not sure if some extra db config is needed to connect to db. Default db configurations are inside `database.yml`
* Run `rails s`. Server should start at `port 5000`
* There is a `.rest` file from which you can make api request. You need to install rest client on your editor.
* Create a user by sending data to POST http://localhost:5000/users to create a user
* Now u should be able to run  `rails db:seeds` to populate db with some data.
* Inside `schema.rb` you can see db schema.
