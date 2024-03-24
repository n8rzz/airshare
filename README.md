# How I start every rails app

## 1. Generate the project

```sh
rails new my_app --database=postgresql --skip-jbuilder --skip-test --css=tailwind --javascript=esbuild
```

## DockerCompose

Create a new file: `docker-compose.yml` and populate it with:

```yml
version: "3.4"

volumes:
  volume_name:
    name: APP_NAME_data

services:
  db:
    image: "postgres:12"
    container_name: "db"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=APP_NAME_development
    ports:
      - "5432:5432"
    volumes:
      - ./.tmp/db:/var/lib/postgresql/APP_NAME_data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      start_period: 10s
      timeout: 4s
      retries: 3
```

## 2. RSpec

To ensure these instructions are up to date, if anything goes wrong please [reference the official documentation](https://github.com/rspec/rspec-rails).

Add the following to the Gemfile:

```ruby
group :development, :test do
  gem 'rspec-rails', '~> 6.0.0'
end
```

Next run the following commands:

```sh
$ rails generate rspec:install
$ bundle binstubs rspec-core
```

Add the following to `config/application.rb` to tweak the rails generators:

```sh
config.generators do |g|
  g.skip_routes true
  g.helper false
  g.assets false
  g.test_framework :rspec, fixture: false
  g.helper_specs false
  g.controller_specs false
  g.system_tests false
  g.view_specs false
end

# GZip all responses
config.middleware.use Rack::Deflater
```

Now we just have some configuration changes to make in the `spec/rails_helper.rb` file.

```ruby
# Uncomment
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

# Then add these to the configuration block
config.fixture_path = "#{::Rails.root}/spec/fixtures"
config.global_fixtures = :all

config.include ActiveJob::TestHelper
config.include ActionMailbox::TestHelper
# config.include Devise::Test::IntegrationHelpers, type: :feature
# config.include Devise::Test::ControllerHelpers, type: :controller
```

Create this file in `spec/support/request_spec_helper.rb`:

```shell
$ mkdir -p ./spec/support && touch request_spec_helper.rb
```

```ruby
module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
    resource
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def json
    JSON.parse(response.body).with_indifferent_access
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
  config.before(:each, type: :request) { host! "my_app.test" }
end
```

Now you can run your specs with `bin/rspec`.

## [FactoryBotRails](https://github.com/thoughtbot/factory_bot_rails)

Add `factory_bot_rails` to your Gemfile

```shell
group :development, :test do
  gem 'factory_bot_rails'
end
```

Create an empty `factories` directory.

```shell
$ mkdir -p ./spec/factories
```

Factory Bot adds a custom generator that can be used like:

```shell
$ rails generate factory_bot:model NAME [field:type field:type] [options]
```

## DatabaseCleaner

Add the following to the Gemfile:

```shell
group :development, :test do
  gem 'database_cleaner'
end
```

Add this to the config section of `spec/rails_helper.rb`

```ruby
config.before(:suite) do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with(:truncation)
end

config.around(:each) do |example|
  DatabaseCleaner.cleaning do
    example.run
  end
end
```

## Static Pages

Add `dotenv-rails` gem to the production group:

```shell
$ bundle add dotenv-rails
```

Create a new controller for static pages

```shell
$ bin/rails g controller Pages home
$ bin/rails generate rspec:request pages
```

Set this route as the `root` route in `config/routes.rb`

```rb
root: pages#home
```

Create the db and start the app

```shell
$ bin/rails db:create
$ bin/rails s
```

The app should load to the default view.

---

## 3. Devise

To ensure these instructions are up to date, if anything goes wrong please [reference the official documentation](https://github.com/heartcombo/devise).

Add the following to the Gemfile:

```ruby
gem "devise"
gem "letter_opener_web" # To easily see the emails devise sends in development
```

Add this to `config/application.rb` to configure devises layout:

```sh
config.to_prepare do
  Devise::SessionsController.layout "auth"
  # DeviseInvitable::RegistrationsController.layout "auth"
  # Devise::InvitationsController.layout "auth"
  Devise::RegistrationsController.layout "auth"
  Devise::ConfirmationsController.layout "auth"
  Devise::UnlocksController.layout "auth"
  Devise::PasswordsController.layout "auth"
  Devise::Mailer.layout "mailer"
end
```

Add these to `app/controllers/application_controller.rb` to protect all routes by default and allow some extra params:

```ruby
before_action :configure_permitted_parameters, if: :devise_controller?
before_action :authenticate_user!

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name terms_and_conditions])
  devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
end
```

Generate the `User` model, and add two additional fields for `first_name` and `last_name`.

```sh
$ rails generate devise:install
$ rails generate devise User
```

#### Setting up letter opener

```ruby
# append to `config/environments/development.rb`
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
config.action_mailer.delivery_method = :letter_opener
```

#### Generate the devise views

This is so we can customise them and add our additional fields in.

```sh
$ rails generate devise:views
```

Go into the views and add additional fields.

## 4. Tailwind UI layout for app / auth pages
