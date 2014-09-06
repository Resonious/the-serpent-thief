namespace :serpent do
  desc "Generate the admin profile. Top secret!"
  task :make_admin, [:email] => :environment do |_t, args|
    admin = Admin.create(email: args[:email], password: 'password', password_confirmation: 'password')

    if admin.valid?
      STDOUT.puts 'Ok done. Password is passsword. Please change it.'
    else
      STDOUT.puts "It didn't work. I don't know why."
    end
  end
end
