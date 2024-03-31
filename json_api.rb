# Load the environment
require_relative 'config/environment'

class JsonApi
  def call(env)
    request = Rack::Request.new(env)
    handle_request(request)
  end

  private

  def handle_request(request)
    case request.path
    when '/create_post'
      create_post(request)
    when '/rate_post'
      rate_post(request)
    when '/top_posts'
      top_posts(request)
    when '/add_feedback'
      add_feedback(request)
    when '/multiple_authors_ips'
      multiple_authors_ips
    else
      not_found
    end
  end

  def parse_json_data(request)
    json_data = request.body.read.force_encoding('UTF-8')
    JSON.parse(json_data)
  end

  def create_post(request)
    data = parse_json_data(request)
    email = data['email']
    title = data['title']
    content = data['content']
    author_ip = request.ip

    user = User.find_or_create_by(email: email)
    post = Post.new(title: title, content: content, author_ip: author_ip, user: user, author_login: email)

    if post.save
      success_response(201, post)
    else
      error_response(422, post.errors.full_messages)
    end
  end

  def rate_post(request)
    data = parse_json_data(request)
    post_id = data['post_id']
    value = data['value']

    post = Post.find_by(id: post_id)

    if post
      post.ratings.create(value: value)
      new_average_rating = post.ratings.average(:value)
      success_response(200, average_rating: new_average_rating)
    else
      not_found_response
    end
  end

  def top_posts(request)
    limit = request.params['limit'].presence || 10
    posts_with_ratings = Post.joins(:ratings)
                             .select('posts.id, posts.title, posts.content, AVG(ratings.value) AS average_rating')
                             .group('posts.id, posts.title, posts.content')
                             .limit(limit)
    success_response(200, posts_with_ratings)
  end

  def add_feedback(request)
    data = parse_json_data(request)
    user_id = data['user_id']
    post_id = data['post_id']
    comment = data['comment']
    owner_id = data['owner_id']

    feedback = Feedback.find_by(user_id: user_id, post_id: post_id, owner_id: owner_id)
    if feedback
      success_response(201, feedback)
    else
      feedback = Feedback.new(user_id: user_id, post_id: post_id, comment: comment, owner_id: owner_id)
      if feedback.save
        success_response(201, feedback)
      else
        error_response(422, feedback.errors.full_messages)
      end
    end
  end

  def multiple_authors_ips
    multiple_authors_ips = Post.group(:author_ip)
                               .having("COUNT(DISTINCT author_login) > 1")
                               .pluck(:author_ip)

    result = multiple_authors_ips.map do |ip|
      authors = Post.where(author_ip: ip).distinct.pluck(:author_login)
      { ip: ip, author_logins: authors }
    end

    success_response(200, result)
  end

  def not_found
    not_found_response
  end

  def success_response(status_code, body)
    [status_code, { 'Content-Type' => 'application/json' }, [body.to_json]]
  end

  def error_response(status_code, errors)
    [status_code, { 'Content-Type' => 'application/json' }, [{ errors: errors }.to_json]]
  end

  def not_found_response
    [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
  end
end
