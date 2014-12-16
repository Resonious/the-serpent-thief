module StoriesHelper
  def clean_page_path(story, page_number, tag = nil)
    story = story.find_by(link: story) unless story.is_a?(Story)
    tag = case tag
          when Tag then tag.value
          else tag
          end

    if story.active?
      if tag
        read_story_page_path(tag, page_number)
      else
        read_page_path(page_number)
      end
    else
      if tag
        read_story_tag_page_path(story.link, tag, page_number)
      else
        read_story_page_path(story.link, page_number)
      end
    end
  end
end
