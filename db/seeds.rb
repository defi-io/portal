# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Currency.count == 0
  Currency.create(usd: 1) 
end

ct = Spina::Page.find_by_name('Cointelegraph')
if ct.nil?
  ct = Spina::Page.new
  ct.title = "Cointelegraph"
  ct.name = "Cointelegraph"
  ct.view_template = "show"
  ct.position = 2
  ct.save!
end

cd = Spina::Page.find_by_name('Coindesk')
if cd.nil?
  cd = Spina::Page.new
  cd.title = "Coindesk"
  cd.name = "Coindesk"
  cd.view_template = "show"
  cd.position = 3
  cd.save!
end

tb = Spina::Page.find_by_name('Theblock')
if tb.nil?
  tb = Spina::Page.new
  tb.title = "Theblock"
  tb.name = "Theblock"
  tb.view_template = "show"
  tb.position = 4
  tb.save!
end

