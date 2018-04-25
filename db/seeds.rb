require_relative '../app'

(1..201).each do |i|
  app_name = "my-app-#{ i }"
  puts "Creating #{ app_name }"
  App.create(name: app_name)
end
