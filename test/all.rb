require          'ostruct'
require          'ohm'
require_relative '../lib/ohm/scope'

class User < Ohm::Model
  collection :posts, :Post
end

class Post < Ohm::Model
  attribute :title
  attribute :body

  unique :title

  index :body

  reference :user, :User

  collection :likes, :Like
end

prepare do
  Ohm.flush
end

setup do
  user = User.create

  [Ohm::Scope.new(Post, user_id: user.id), user]
end

test '#create saves model with overridden attributes' do |posts, user|
  title = 'overrides references'
  post  = posts.create(title: title, user: User.create)

  assert       post.id
  assert_equal post.title, title
  assert_equal post.user,    user
  assert_equal post.user_id, user.id

  title = 'overrides ids'
  post  = posts.create(title: title, user_id: User.create.id)

  assert       post.id
  assert_equal post.title, title
  assert_equal post.user,    user
  assert_equal post.user_id, user.id
end

test '#build initializes a new instance of klass arg' do |posts, user|
  klass = OpenStruct
  title = 'in scope'
  post  = posts.build(klass, title: title)

  assert       !post.id
  assert_equal post.class, klass
  assert_equal post.title, title

  post = posts.build(title: title) # klass should default to model

  assert       !post.id
  assert_equal post.class, Post
  assert_equal post.title, title
end

test '#[] queries for single record by id in scope' do |posts, user|
  post = posts.create(title: 'in scope')

  assert_equal posts[post.id], post

  post = Post.create(title: 'out of scope')

  assert_equal posts[post.id], nil
end

test '#fetch queries for many records by id in scope' do |posts, user|
  collection = []

  2.times { |i| collection << posts.create(title: "in scope #{i}") }

  assert_equal posts.fetch(collection.collect(&:id)), collection

  collection << Post.create(title: 'out of scope')

  assert posts.fetch(collection.collect(&:id)) != collection
end

test '#with queries single record by unique index in scope' do |posts, user|
  title = 'in scope'
  post  = posts.create(title: title)

  assert_equal posts.with(:title, title), post

  title = 'out of scope'
  Post.create(title: title)

  assert_equal posts.with(:title, title), nil
end

test '#with raises for non-unique index' do |posts, user|
  assert_raise(Ohm::IndexNotFound) do
    posts.with(:body, 'body')
  end
end

test '#exists? checks if record with id exists in scope' do |posts, user|
  post = posts.create(title: 'in scope')

  assert posts.exists?(post.id)

  post = Post.create(title: 'out of scope')

  assert !posts.exists?(post.id)
end

test '#all returns all records in scope' do |posts, user|
  2.times { |i| posts.create(title: "in scope #{i}") }

  Post.create(title: 'out of scope')

  assert posts.all.count > 0

  posts.all.each do |post|
    assert_equal post.user, user
  end
end

test '#find queries for records by indexes in scope' do |posts, user|
  body = 'correct body'

  2.times { |i| posts.create(title: "in scope #{i}", body: body) }

  posts.create(title: 'in scope wrong body', body: 'wrong')

  Post.create(title: 'out of scope correct body', body: body)

  posts.find(body: body).each do |post|
    assert_equal post.body, body
    assert_equal post.user, user
  end
end
