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

tb = Spina::Page.find_by_name('Decrypt')
if tb.nil?
  tb = Spina::Page.new
  tb.title = "Decrypt"
  tb.name = "Decrypt"
  tb.view_template = "show"
  tb.position = 4
  tb.save!
end

dl = Spina::Page.find_by_name('Dlnews')
if dl.nil?
  dl = Spina::Page.new
  dl.title = "Dlnews"
  dl.name = "Dlnews"
  dl.view_template = "show"
  dl.position = 5
  dl.save!
end

is = Spina::Page.find_by_name('Insight')
if is.nil?
  is = Spina::Page.new
  is.title = "Insight"
  is.name = "Insight"
  is.view_template = "show"
  is.position = 1
  is.save!
end

ancestry = News::Ct.new.get_ancestry('Insight')

mc = Spina::Page.find_by_name('Multicoin')
if mc.nil?
  mc = Spina::Page.new
  mc.title = "Multicoin"
  mc.name = "Multicoin"
  mc.view_template = "show"
  mc.position = 2
  mc.ancestry = ancestry
  mc.save!
end

pd = Spina::Page.find_by_name('Paradigm')
if pd.nil?
  pd = Spina::Page.new
  pd.title = "Paradigm"
  pd.name = "Paradigm"
  pd.view_template = "show"
  pd.position = 2
  pd.ancestry = ancestry
  pd.save!
end

tb = Spina::Page.find_by_name('Theblock')
if tb.nil?
  tb = Spina::Page.new
  tb.title = "Theblock"
  tb.name = "Theblock"
  tb.view_template = "show"
  tb.position = 10
  tb.save!
end

