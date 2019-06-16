# Docker Ruby Boiler Plate

## Introduction

The intention of this project is to provide an easy to use boiler plates with different ruby projects (Specifically web applications).

## Setup
In order to setup this boilerplate:

* Clone the repository.
* Replace the word `APP_NAME` with your application name in both `dockerfile` and `docker-compose.yml`
* Add the needed build dependencies to your `.build-deps` file, you can check the `.build-deps.sample` file for examples.
* Add your gem dependencies to the gemfile.
* Alter `docker-compose.yml` to add your dependencies, there are examples there for mariadb and postgresql.
* Make sure your `start_dev_server` has the needed commands to start your development server.
* Alter your `.env.dev` to supply the correct credentials for your database and use the correct hostname.
* Alter `makefile` to enable the needed targets.

## Usage

* After finishing the setup, running the command `make setup` should build your needed images, install necessary dependencies and setup your databases if needed.
* Running `make dev` will fire up a shell inside your container and then you can treat it like your usual non dockerized development environment.

