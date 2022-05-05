# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_05_053832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "explanations", force: :cascade do |t|
    t.string "explanation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "assignment_id"
    t.bigint "worker_id"
    t.bigint "hit_id"
    t.index ["hit_id"], name: "index_explanations_on_hit_id"
    t.index ["worker_id"], name: "index_explanations_on_worker_id"
  end

  create_table "hits", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "worker_id"
    t.bigint "article_id"
    t.string "assignment_id"
    t.string "cause"
    t.string "effect"
    t.string "passage"
    t.string "question"
    t.index ["article_id"], name: "index_hits_on_article_id"
    t.index ["worker_id"], name: "index_hits_on_worker_id"
  end

  create_table "passages", force: :cascade do |t|
    t.string "passage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "article_id"
    t.string "patterns", default: ""
    t.integer "retrieved", default: 0
    t.index ["article_id"], name: "index_passages_on_article_id"
  end

  create_table "workers", force: :cascade do |t|
    t.string "worker_id"
    t.integer "quiz_attempts"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "hit_submits", default: 0
    t.integer "hits_since_check", default: 0
    t.decimal "grammar_score"
    t.boolean "qualified", default: false
    t.string "checked_status", default: "unchecked"
    t.string "feedback"
    t.integer "explanation_submits", default: 0
    t.integer "explanations_since_check", default: 0
  end

  add_foreign_key "explanations", "hits"
  add_foreign_key "explanations", "workers"
  add_foreign_key "hits", "articles"
  add_foreign_key "hits", "workers"
  add_foreign_key "passages", "articles"
end
