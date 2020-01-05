# Apigator9999

## About

Apigator9999 is the back-end service of [agator9999](https://github.com/agatheblues/agator9999), a personal music library aggregator. This API is built with Ruby on Rails, with a PostgreSQL database. 

## Setup the databases

```
psql -U {pg user} -f postgresql_setup.txt
ruby bin/rails db:migrate
```

## Migrate data from Firebase

In case you have been using the older version of Agator9999 with Firebase as a backend:

1. Export your Firebase data to JSON
2. Copy it to `firebase_dump.rb`
3. Run `rails runner <PATH_TO_FILE/migrate_data_from_firebase.rb>`

Done!

