# TankGirl brings heavy machinery for your Cucumber/Turnip steps

[TankGirl](http://en.wikipedia.org/wiki/Tank_Girl) is a DSL for mapping your application navigation flow and page elements into natural language expressions.
Once you define your mappings you can query them and build acceptance steps dynamically.

The ultimate design goal of TankGirl is to ease step definition and to abstract the DOM and the navigation from your acceptance tests.

## Installation

Add this line to your application's Gemfile:

    gem 'tank_girl'

And then execute:

    $ bundle

## Usage

Define your resources:

```ruby
require 'tank_girl'

RSpec.configure do |config|
  config.include(TankGirl::Helpers, feature: true)
end

TankGirl.configure do
  selector "header", "#header"
  selector "footer", "#footer"

  page "blog home" do
    url { "/posts" }
    selector "post(s)", '.post'
    selector "the :title post", '.post', placeholder: true
  end

  page "my blog posts" => "blog home" do
    url { author_posts_url(tank_girl.get(:user)) }
  end

  page ":author_name posts" => "blog home" do
    url { |author_name| author_posts_url(Author.find_by_name!(author_name)) }
  end
end

step "I sign in as an user" do
  tank_girl.set(:user, FactoryGirl.create(:user))
end

TankGirl.configuration.pages.each do |page|
  step "I visit #{page.name} page" do |*args|
    tank_girl.set(:page, tank_girl.pages.find(page.name))
    visit instance_exec(*args, &tank_girl.page.block)
  end
end

TankGirl.configuration.selectors.each do |selector|
  step "I should see :count #{selector.name}" do |count|
    page.should have_selector(tank_girl.get(:page).selectors.find(selector.name), count: count)
  end
end

TankGirl.configuration.selectors.where(placeholder: true).each do |selector|
  step "I should see #{selector.name}" do |placeholder|
    page.should have_selector(tank_girl.get(:page).selectors.find(selector.name), text: placeholder)
  end
end

```

Use them on your features:

```
Feature: Blog

  Background:
    Given a blog post titled "Introducing Tank Girl" and authored by "knoopx"
    And a blog post titled "Ruby rocks" and authored by "somebody else"

  Scenario: Lists the blogs posts
    When I visit blog home page
    Then I should see 2 posts

  Scenario: Lists the blogs posts by author
    When I visit "knoopx" posts page
    Then I should see the "Introducing Tank Girl" post
    And I should see the "knoopx"Tank Girl" post

  Scenario: Lists my posts
    When I sign in as an user
    And I visit my blog posts page
    Then I should see 1 post
    And I should see "Logged in as knoopx" within header

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
