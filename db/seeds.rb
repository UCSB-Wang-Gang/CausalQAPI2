# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Meeting.create([
#   {
#     :title      => "This meeting parses fine",
#     :startDate  => DateTime.new(2009,9,1,17),
#     :endDate    => DateTime.new(2009,9,1,19)
#   },
#   {
#     :title      => "This meeting errors out",
#     :startDate  => DateTime.new(2009,9,14,8),
#     :endDate    => DateTime.new(2009,9,14,9)
#   }
# ])

seed_art = Article.create(
  title: "seed article",
  created_at:  DateTime.new(2022, 4, 4, 8),
  updated_at:  DateTime.new(2022, 4, 4, 8),
)

Passage.create(
  passage: "this is a seed passage",
  created_at:  DateTime.new(2022, 4, 4, 8),
  updated_at:  DateTime.new(2022, 4, 4, 8),
  article_id: 0,
)

seed_worker = Worker.create(
  {
    worker_id: "seed0",
    quiz_attempts: 1,
    qualified: true,
    created_at:  DateTime.new(2022, 4, 4, 8),
    updated_at:  DateTime.new(2022, 4, 4, 8),
    grammar_score: 0,
  }
)

seed_hit = Hit.create(
  question: "q",
  answer: "a",
  created_at:  DateTime.new(2022, 4, 4, 8),
  updated_at:  DateTime.new(2022, 4, 4, 8),
  worker_id: seed_worker.id,
  article_id: seed_art.id,
  explanation: "[{\"entry\": \"dummy entry\"}]",
  assignment_id: "seed_hit0",
  cause: "cause 0",
  effect: "effect 0",
  passage: "passage 0",
)
