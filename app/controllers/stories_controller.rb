class StoriesController < InheritedResources::Base
  before_filter :permitted_params
  before_filter :authenticate_admin!, except: [:show, :read, :index]

  def index
    @stories = admin_signed_in? ? Story.all : Story.with_pages
  end

  def show
    super do |format|
      format.html do
        return redirect_to action: :read, story_link: @story.link
      end
    end
  end

  def read
    unless Story.any?
      text = "There aren't even any stories! What?!"
      text += " <a href='#{new_story_path}'>Make one.</a>" if admin_signed_in?
      return render inline: text, status: 404
    end

    if params[:story_link]
      @story = Story.where(link: params[:story_link]).first

      # puts Story.all.map(&:link)
      # puts params[:story_link]

      return render '404', status: 404, locals: {link: params[:story_link]} unless @story
      @page = @story.pages.where(number: params[:page] || 1).first
    else
      if cookies[:page_id] && Page.where(id: cookies[:pate_id]).exists?
        @page = Page.find cookies[:page_id]
        @story = @page.story
      else
        @story = Story.where(active: true).first || Story.order("created_at DESC").first
        @page = @story.first_page
      end
    end


    if @page.nil? || (!@page.published && !admin_signed_in?)
      render 'no_such_page', locals: { page_number: params[:page] }
    else
      @blog_post_ready = @page.blog_post && @page.blog_post.content && !@page.blog_post.content.empty?
      cookies[:page_id] = @page.id
      render 'show'
    end
  end

  private
  def permitted_params
    params.permit(:story_link, :page, story: [:name, :link, :active])
  end
end