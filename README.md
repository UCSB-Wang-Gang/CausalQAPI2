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

## ERD
![ERD](https://i.imgur.com/YxPcsRO.png)

## 📍 Endpoints
List of endpoints with their functionalities. 

### 📉 MTurk
- **GET** `/api/worker_qualification/:worker_id`
  - Returns the given `worker_id`'s qualification
- **GET** `/api/get_passage`
  - Returns a random passage and deletes it from the database
- **GET** `/api/get_hit/:eval_status(/:show_worker_stats)`
  - Returns a random hit that doesn't have an explanation attached to it with the given eval status and optionally returns the worker's stats
- **GET** `/api/check_worker_info/:worker_id`
  - Gets the information of the given `worker_id` or creates a new worker if the given `worker_id` doesn't exist
- **POST** `/api/add_hit`
  - Creates a new hit
- **POST** `/api/explanation`
  - Creates a new explanation

### ✅ Validation
- **GET** `/api/get_hits/:worker_id`
  - Returns all hits from given `worker_id`
- **GET** `/api/get_explanations/:worker_id`
  - Returns all explanations from given `worker_id`
- **GET** `/api/get_top_k/:num_workers/:criteria`
  - Returns the top `num_workers` workers based on the specified `criteria`
- **GET** `/api/get_hit_metrics`
  - Returns the hit metrics such as how many good hits are currently left in the database
- **GET** `/api/get_speed_bumped`
  - Returns the workers who have been blocked by our speed bumping mechanism on our stage 1 task
- **GET** `/api/get_bumped2`
  - Returns the workers who have been blocked by our speed bumping mechanism on our stage 2 task
- **GET** `/api/leaderboard`
  - Returns the validator's leaderboard
- **POST** `/api/eval_hit/:hit_id/:new_eval_field`
  - Assigns the `new_eval_field` to the given `hit_id`
- **POST** `/api/eval_all_s1_by/:worker_id/:new_status`
  - Assigns all hits from the given `worker_id` to the given `new_status`
- **POST** `/api/reset_last_check/hits/:worker_id`
  - Resets the number of hits submitted since last check for the given `worker_id`
- **POST** `/api/reset_last_check/explanations/:worker_id`
  - Resets the number of explanations submitted since last check for the given `worker_id`
- **POST** `/api/update_checked_status/:stage_num/:worker_id/:new_status`
  - Assigns the `new_status` to the given `worker_id` for the given `stage_num`

### ⚙️ Miscellaneous/Deprecated
- **GET** `/`
  - Landing page test
- **GET** `/api/count_passages`
  - Returns number of passages
- **POST** `/api/qualify_worker/:worker_id/:quiz_attempts`
  - Qualifies the given `worker_id` and saves its `quiz_attempts`
- **POST** `/api/add_passage`
  - Adds a new passage to the database
- **POST** `/api/reset_worker_hit_count/:worker_id`
  - Resets the hit counts and ALL other hit counting metrics of the given `worker_id`
- **POST** `/api/reset_top_worker_hit_count`
  - Resets the hit counts and ALL other hit counting metrics for the top worker

## 💡 Feature Requests
If more features are needed, please open an issue on this repository. 
