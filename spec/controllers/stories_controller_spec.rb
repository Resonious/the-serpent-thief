require 'spec_helper'

describe StoriesController do
  let(:story) { create :story_with_pages }
  let(:admin) { create :admin }

  describe 'GET #read' do
    it 'assigns @story to the story with the given link' do
      story.link = 'test-story'; story.save
      get :read, story_link: 'test-story'
      expect(response.status).to_not eq 404
      expect(assigns(:story)).to eq story
    end

    it 'defaults to page 1' do
      story.link = 'test-story'; story.save
      get :read, story_link: 'test-story'
      expect(response.status).to_not eq 404
      expect(assigns(:page)).to eq Page.where(number: 1).first
    end

    context 'with no params' do
      context 'and a page_id cookie' do
        it 'goes to the specified page and its associated story' do
          cookies[:page_id] = story.pages[1].id
          get :read
          expect(response.status).to_not eq 404
          expect(assigns(:page)).to eq story.pages[1]
        end
      end

      it 'shows the active story on page 1' do
        story
        active_story = create :story_with_pages, active: true
        get :read
        expect(response.status).to_not eq 404
        expect(assigns(:page)).to eq active_story.first_page
      end
    end
  end
end