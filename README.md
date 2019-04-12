# Apigator9999

## About

Apigator9999 is the back-end service of [agator9999](https://github.com/agatheblues/agator9999), a personal music library aggregator. This API is built with Ruby on Rails, with a PostgreSQL database. 

## Setup the databases

```
psql -U {pg user} -f postgresql_setup.txt
ruby bin/rails db:migrate
```
