require 'spec_helper'

describe Page do
  context 'when assigned to a story' do
    subject(:subject) { create :page_with_story }

    it { should validate_uniqueness_of(:number).scoped_to(:story_id) }
    # it { should validate_presence_of :number }
  end
  it { should validate_presence_of :content }

  it 'should increment number automatically when added to a story' do
    story = create :story
    page1 = create :page
    page2 = create :page

    story.pages << page1
    story.pages << page2

    expect(page1.number).to eq 1
    expect(page2.number).to eq 2
  end
end