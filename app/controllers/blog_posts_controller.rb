class BlogPostsController < InheritedResources::Base
  respond_to :html, :js
  before_filter :authenticate_admin!, except: [:show]

  def show
    super do |format|
      format.html do
        redirect_to read_story_page_path(@blog_post.page.story.link, @blog_post.page.number)
      end
    end
  end

  private

  def permitted_params
    params.permit(blog_post: [:content])
  end
end
