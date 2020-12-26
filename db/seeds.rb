# メインのサンプルユーザーを1人作成する
User.create!(full_name: "Toshiaki Takahashi",
             name:  "Toshi",
             email: "insta-clone@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  full_name = Faker::Name.name
  name  = Faker::JapaneseMedia::DragonBall.character
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(full_name: full_name,
               name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
