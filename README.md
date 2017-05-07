# Ohm::Scope

Ohm::Scope wraps Ohm::Model to let you work with user
input in a way that is both safe and familiar to Ohm users.

## Installation

`$ gem install ohm-scope`

## Usage

Ohm::Scope implements all of Ohm::Model's public class methods while maintaining
the same contract as using Ohm::Model directly. If you're comfortable with Ohm::Model,
you should feel at home using Ohm::Scope. The one method new to Ohm::Scope
is the `#build` method. It is a factory method that delegates
to the scope's model class `::new` method by default, but also lets us
pass an argument for a different class if we want to construct something other
than a model.

### Example

```ruby
  require 'syro'
  require 'ohm'
  require 'ohm/scope'

  class User < Ohm::Model
    collection :posts, :Post
  end

  class Post < Ohm::Model
    attribute :title

    unique :title

    reference :user, :User
  end

  class Deck < Syro::Deck
    # A convenience helper for initializing scopes.
    def scope(model, user)
      Ohm::Scope.new(model, { user_id: user.id })
    end

    # A pretend authentication solution.
    def curent_user
      User.with(:auth_token, req.session[:auth_token])
    end
  end

  App = Syro.new(Deck) do
    on 'posts' do
      # Create a new scope that will allow the `current_user` to
      # have access to only their posts.
      @posts = scope(Post, current_user)

      post do
        # With our `@posts` scope, we can safely create new records via request params.
        # The params should probably still be validated for correctness,
        # but the scope protects us from the params containing a `:user_id` field
        # with an id other than that of the authenticated user.
        res.json @posts.create(params)
      end

      on :id do
        # Finders are also scoped. If the url param `:id` contains
        # an id for a post that doesn't belong to the authenticated user,
        # our scope will return nil as if it doesn't exist.
        @post = @posts[inbox[:id]]

        patch do
          ...
        end

        delete do
          ...
        end
      end
    end
  end
```
