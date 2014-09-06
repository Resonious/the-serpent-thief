require 'spec_helper'

describe Story do
  it 'should only allow one active story' do
    story1 = create :story, name: 'First Story'
    story2 = create :story, name: 'Second Story'

    story1.active = true
    story1.save
    expect(story1).to be_valid

    story2.active = true
    expect(story2).to_not be_valid
  end
end