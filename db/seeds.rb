User.create!(name:  "Example User",
    email: "example@railstutorial.org",
    personal_id: "exampleuser0101",
    password:              "foobar",
    password_confirmation: "foobar",
    admin:     true,
    activated: true,
    activated_at: Time.zone.now)

User.create!(name:  "Akimu Hamaguchi",
        email: "akimu-hamaguchi@i.softbank.jp",
        personal_id: "akimuhamaguchi0801",
        password:              "foobar",
        password_confirmation: "foobar",
        admin:     true,
        activated: true,
        activated_at: Time.zone.now)


99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
personal_id = "username#{n+1}"
password = "password"
User.create!(name:  name,
     email: email,
     personal_id: personal_id,
     password:              password,
     password_confirmation: password,
     activated: true,
     activated_at: Time.zone.now)
end

# 最初の6人にmicropostを追加する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }


# 5人がexampleuser0101に対してリプを飛ばす
users = User.order(:created_at).take(5)
# 3.times do |n|
#   content = Faker::Lorem.sentence(5)
#   personal_id = "username#{n+1}"
#   users.each { |user| user.microposts.create!(content: "@#{personal_id} #{content}") }
# end
users.each do |user|
  content = Faker::Lorem.sentence(5)
  user.microposts.create!(content: "@exampleuser0101 #{content}") 
end