# Docker Ruby Boiler Plate

## Introduction

The intention of this project is to provide an easy to use boiler plates with different ruby projects (Specifically web applications).

## Setup
In order to setup this boilerplate:

* Clone the repository.
* Remove the local git repo with `rm -r .git` and initiate your own git repo for your project.
* Replace the word `APP_NAME` with your application name in both `dockerfile` and `docker-compose.yml`
* Alter `docker-compose.yml` to add your dependencies, there are examples there for mariadb and postgresql.
* Add your gem dependencies to the gemfile.
* Run `make setup` and add the needed build dependencies to your `.build-deps` file, you can check the `.build-deps.sample` file for examples.
* Keep running `make setup` until your bundle installation works without errors.
* Make sure your `start_dev_server` has the needed commands to start your development server.
* Alter your `.env.dev` to supply the correct credentials for your database and use the correct hostname And make sure your application database connections set to use environmental variables
* Alter `makefile` to enable the needed targets.


### Example setup of Rails application called test_app with mariadb from scratch:
* Rename the folder to `test_app` after cloning
* Replace the word `APP_NAME` in `dockerfile` and `docker-compose.yml` to `test_app`
* Go to docker-compose.yml and uncomment mariadb services so it looks like this:
```
version: "3.7"
services:
  web:
    build:
      context: .
      target: dev
    env_file:
      - .env.dev
    stdin_open: true
    tty: true
    command: ./bin/start_dev_server
    volumes:
      - ".:/test_app"
      - bundle:/bundle
    ports:
      - "3000:3000"
    depends_on:
      - db

  db:
    image: "mariadb:10.3"
    environment:
      MYSQL_ROOT_PASSWORD: db_password
volumes:
  bundle:
```

* Add `rails` and `mysql2` to your gemfile.
* Running `make setup` the bundle installation step will fail.
* Edit your `.build-deps` file to have the needed build dependencies like this:
```
build-base
mysql-dev
nodejs
tzdata
```
* Run make setup again and this time your bundle will install.
* Run `make dev` to jump into the container shell.
* Run `rails new . -d mysql` in the container shell to generate the rails project. Accept the overwrite in case of conflicts like gemfile or readme.
* Alter your `.env.dev` to look as following:
```
DATABASE_PASSWORD=db_password
DATABASE_HOST=db
DATABASE_USERNAME=root

```
* Alter your database.yml to use env vars you want your defaults to look something like this:
```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch("DATABASE_USERNAME") { root } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { '' } %>
  host: <%= ENV.fetch("DATABASE_HOST") { 'localhost' } %>
```
* Change your makefile to look like this:
```
dc=docker-compose -f docker-compose.yml $(1)
dc-run=$(call dc, run --rm web $(1))

usage:
    @echo "Available targets:"
    @echo "  * setup                  - Initiates everything (building images, installing gems, creating db and migrating"
    @echo "  * build                  - Build image"
    @echo "  * bundle                 - Install missing gems"
    @echo "  * db-migrate             - Runs the migrations for dev database"
    @echo "  * db-test-migrate        - Runs the migrations for test database"
    @echo "  * dev                    - Fires a shell inside your container"
    @echo "  * run                    - Runs the development server"
    @echo "  * tear-down              - Removes all the containers and tears down the setup"
    @echo "  * stop                   - Stops the server"
    @echo "  * test                   - Runs rspec"

# With db
setup: build bundle db-create db-migrate db-test-migrate

build:
    $(call dc, build)
bundle:
    $(call dc-run, bundle install)
dev:
    $(call dc-run, ash)
run:
    $(call dc, up)
tear-down:
    $(call dc, down)
stop:
    $(call dc, stop)
console:
    $(call dc-run, bundle exec rails console)
db-create:
    $(call dc-run, bundle exec rake db:create)
db-migrate:
    $(call dc-run, bundle exec rake db:migrate)
db-test-migrate:
    $(call dc-run, bundle exec rake db:migrate RAILS_ENV=test)


# .PHONY: test
# test:
#   $(call dc-run, bundle exec rspec)

```
* Rerun `make setup` to setup the databases.
* Run `make up` and you should find your app running on http://localhost:3000
## Usage

* After finishing the setup, running the command `make setup` should build your needed images, install necessary dependencies and setup your databases if needed.
* Running `make dev` will fire up a shell inside your container and then you can treat it like your usual non dockerized development environment.

