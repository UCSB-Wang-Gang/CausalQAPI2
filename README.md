# 🐥 CausalQAPI2
This is the second version of our API to track our MTurk data collection pipeline. The original API interfaced with a Redis Cloud instance as its primary database; however, Redis was insufficient for us because it lacked many SQL features, such as foreign keys. The API is currently hosted with the base URL being `https://the.mturk.monster:50000`. 

## 💻 The Tech
This API was created using Ruby on Rails connected to a PostgreSQL database. 

## 🛠 Setup
CausalQAPI2 runs on Ruby 3.0.0. To setup the API for local development you will need to install its dependencies. To do so, run the command:
```
bundle install
```

Afterwords, you must configure the Redis integration by configuring the following environment variables:
```
export POSTGRESQL_USERNAME=YOUR_USERNAME
export POSTGRESQL_PASSWORD=YOUR_PASSWORD
```

## 💡 Feature Requests
If more features are needed, please open an issue on this repository. 