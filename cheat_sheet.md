# Cheat sheet

### Generate model
```
$ rails generate model Hoge fuga_id:integer foo:float bar:float timestamp:datetime
```

### Migration
```
$ rake db:migrate
```

### Generate controller
```
# example
rails generate controller Hoge
```

### Create app on Heroku
```
$ bundle exec heroku create Hoge
```

### Deploy Heroku
```
$ git push heroku master
$ heroku run rake db:migrate
$ bundle exec heroku open
```

### Test
```
$ bundle exec rake test
```

### Settings

##### postgresql
```
$ heroku addons:create heroku-postgresql
```

##### cron
```
# example (local)
$ rails runner Tasks::Hoge.execute
# example (heroku)
$ heroku run rails runner Tasks::Hoge.execute
$
# example (local)
# register
$ bundle exec whenever --update-crontab
# delete
$ bundle exec whenever --clear-crontab
$
# example (heroku)
# create scheduler
$ heroku addons:create scheduler:standard
# test scheduler
$ heroku run rake update_feed
# set scheduler
$ heroku addons:open scheduler
```

##### rails_admin
install devise
```
$ rails g devise:install
$ rails g devise user
```
install rails_admin
```
# rails_admin

$ rails g rails_admin:install
```
```rb
# config/initializers/rails_admin.rb
# comment out below

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end 
  config.current_user_method(&:current_user)
```
install cancan
```
# cancan

$ rails g cancan:ability
```
```rb
# app/models/ability.rb

class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :access, :rails_admin   # grant access to rails_admin
      can :manage, :all           # allow superadmins to do anything
    end 
  end
end
```
```
$ rails g migration AddAdminToUser admin
$ bundle exec rake db:migrate
```
```slim
# app/views/home/index.html.slim

h1 Home#index

- if user_signed_in?
  |  Logged in as
  strong
    = current_user.email
  | .
  = link_to "Settings", edit_user_registration_path, :class => "navbar-link"
  |  |
  = link_to "Logout", destroy_user_session_path, method: :delete, :class => "navbar-link"
- else
  = link_to "Sign up", new_user_registration_path, :class => 'navbar-link'
  |  |
  = link_to "Login", new_user_session_path, :class => 'navbar-link'

p Find me in app/views/home/index.html.slim
```
```
# local

$ rails c
> user = User.find(1)
> user.update_attribute(:admin, "true")

# heroku

$ heroku run rails c
> user = User.find(1)
> user.update_attribute(:admin, "true")
```
```rb
# config/initializers/rails_admin.rb
# comment out below

  ## == Cancan ==
  config.authorize_with :cancan
```
