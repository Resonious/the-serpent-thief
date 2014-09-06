FactoryGirl.define do
  factory :story do
    sequence(:name) { |n| "Test Story #{n}" }
    sequence(:link) { |n| "test-story-#{n}" }
    active false

    factory :active_story do
      active true
    end

    factory :story_with_pages do
      after(:create) do |story|
        story.pages << create(:page, content: 'First page content!')
        story.pages << create(:page, content: 'Now for second page content!')
        story.pages << create(:page, content: 'And finally, the third page content.')
      end
    end
  end

  factory :page do
    sequence(:content) do |n|
      %{Here is the test content of a test page created by a factory
        using FactoryGirl for Ruby on Rails. - ##{n}}
    end
    factory :page_with_story do
      association(:story) { :story }
    end
  end
end