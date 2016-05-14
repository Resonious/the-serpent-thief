module Content
  extend ActiveSupport::Concern

  included do
    before_save :render_content
  end

  def render_content
    return if content.nil?
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    self.rendered_content = markdown.render(content)
  end
end
