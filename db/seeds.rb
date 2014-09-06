# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

story = Story.create name: 'Test Story', link: 'test-story', active: true

story.pages << Page.create(content: "Here is the first page of the seeded test story.")
story.pages << Page.create(content: "Page 2, amazing! I wonder how many pages could possibly be in this story.")
story.pages << Page.create(content: %{
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  })
story.pages << Page.create(content: "Insert more garbage text here.")

a = Admin.create email: 'admin@test.com', password: 'pw4admin', password_confirmation: 'pw4admin'
if a.valid?
  puts "Created default user."
else
  puts "Couldn't create default user."
end
