# Load the environment
require_relative '../config/environment'

# Generate 100 authors
authors = []
100.times do
  authors << { email: Faker::Internet.unique.email }
end
User.insert_all authors

# Generate 50 unique IPs
ips = Array.new(50) { Faker::Internet.unique.ip_v4_address }

# Generate 200,000 posts
posts = []
authors = User.all
200_000.times do
  user = authors.sample
  author_ip = ips.sample

  posts << {
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraphs(number: 3).join("\n"),
    author_login: user[:email],
    author_ip: author_ip,
    user_id: user.id
  }
end
Post.insert_all posts

# Generate 10,000 post feedbacks
feedbacks = []
post_ids = Post.pluck(:id)
10_000.times do
  feedbacks << {
    post_id: post_ids.sample,
    comment: Faker::Lorem.paragraph,
    owner_id: authors.sample.id
  }
end
Feedback.insert_all feedbacks

# Generate 50 user feedbacks
user_feedbacks = []
50.times do
  user_feedbacks << {
    user_id: authors.sample.id,
    post_id: post_ids.sample,
    comment: Faker::Lorem.paragraph,
    owner_id: authors.sample.id
  }
end
Feedback.insert_all user_feedbacks

