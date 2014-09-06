require 'spec_helper'

describe 'stories/index.html.erb' do
  let!(:story) { create :story_with_pages }
  let(:page) { story.pages.first }
  let(:admin)  { create :admin }

  context 'when an admin is logged in' do
    before(:each) { assign :current_admin, admin }

    it 'should have edit buttons for the stories'
    it 'should have a "create new story" button'
    it 'should link to stories with pages'
  end
  context 'when there is no admin logged in' do
    it 'should not have edit buttons for the stories'
    it 'should not link to stories without pages'
  end
end