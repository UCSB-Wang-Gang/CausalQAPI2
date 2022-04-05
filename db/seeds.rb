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
  title: 'seed article',
  created_at: DateTime.new(2022, 4, 4, 8),
  updated_at: DateTime.new(2022, 4, 4, 8)
)

Passage.create(
  passage: 'this is a seed passage',
  created_at: DateTime.new(2022, 4, 4, 8),
  updated_at: DateTime.new(2022, 4, 4, 8),
  article_id: seed_art.id
)

seed_worker = Worker.create(
  worker_id: 'seed0',
  quiz_attempts: 1,
  qualified: true,
  created_at: DateTime.new(2022, 4, 4, 8),
  updated_at: DateTime.new(2022, 4, 4, 8),
  grammar_score: 0,
  submissions: 2,
  submissions_since_check: 2
)

dummy_worker = Worker.create(
  worker_id: 'dummy1',
  quiz_attempts: 8,
  qualified: false,
  created_at: DateTime.new(2022, 4, 4, 8),
  updated_at: DateTime.new(2022, 4, 4, 8),
  grammar_score: -200,
  submissions: 1,
  submissions_since_check: 1
)

Hit.create([
             {
               question: 'seed Q1',
               answer: 'seed A1',
               created_at: DateTime.new(2022, 4, 4, 8),
               updated_at: DateTime.new(2022, 4, 4, 8),
               worker_id: seed_worker.id,
               article_id: seed_art.id,
               explanation: '[{"entry": "dummy entry"}]',
               assignment_id: 'seed_hit1',
               cause: 'seed C1',
               effect: 'seed E1',
               passage: 'seed P1'
             },
             {
               question: 'seed Q2',
               answer: 'seed A2',
               created_at: DateTime.new(2022, 4, 4, 8),
               updated_at: DateTime.new(2022, 4, 4, 8),
               worker_id: seed_worker.id,
               article_id: seed_art.id,
               explanation: '[{"entry": "dummy entry"}]',
               assignment_id: 'seed_hit2',
               cause: 'seed C2',
               effect: 'seed E2',
               passage: 'seed P2'
             },
             {
               question: 'dummy Q1',
               answer: 'dummy A1',
               created_at: DateTime.new(2022, 4, 4, 8),
               updated_at: DateTime.new(2022, 4, 4, 8),
               worker_id: dummy_worker.id,
               article_id: seed_art.id,
               explanation: '[{"entry": "dummy entry"}]',
               assignment_id: 'dummy_hit',
               cause: 'dummy C1',
               effect: 'dummy E1',
               passage: 'dummy P1'
             }
           ])
