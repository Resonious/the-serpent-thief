require 'spec_helper'

describe 'stories/show.html.erb' do
  let!(:story) { create :story_with_pages }
  let(:page) { story.pages.first }

  it 'should say so if the current page is not published' do
    page.published = false
    page.save
    expect(page).to be_valid

    assign(:story, story)
    assign(:page, page)
    render
    expect(rendered).to include "This page is not currently published."
  end

  it 'should not mention it if the page is published' do
    page.published = true
    page.save
    expect(page).to be_valid

    assign(:story, story)
    assign(:page, page)
    render
    expect(rendered).to_not include "This page is not currently published."
  end
end