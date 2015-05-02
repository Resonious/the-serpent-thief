class StoriesController < InheritedResources::Base
  include StoriesHelper

  before_filter :permitted_params
  before_filter :authenticate_admin!, except: [:home, :show, :read, :read_story_tag, :index, :contents]

  def index
    @stories = admin_signed_in? ? Story.all : Story.with_pages
  end

  def show
    super do |format|
      format.html do
        return redirect_to clean_page_path(@story, 1)
      end
    end
  end

  def home
    # TODO remember position via cookies.
    redirect_to read_page_path(load_cookie_for(nil))
  end

  def contents
    if params[:story]
      @story = Story.where(link: params[:story]).first
    else
      @story = Story.active
    end
    render_404 and return if @story.nil?
  end

  def read
    unless Story.any?
      text = "There aren't even any stories! What?!"
      text += " <a href='#{new_story_path}'>Make one.</a>" if admin_signed_in?
      return render inline: text, status: 404
    end

    story_or_tag = params[:story_or_tag]
    page_number  = params[:page]
    if page_number.nil?
      return redirect_to read_story_page_path(
        story_or_tag, load_cookie_for(story_or_tag)
      )
    else
      store_cookie_for(story_or_tag, page_number)
    end

    if story_or_tag.nil?
      @story = Story.active
      @page  = @story.pages.find_by(number: page_number)

    elsif Story.where(link: story_or_tag).exists?
      @story = Story.find_by(link: story_or_tag)
      return redirect_to read_page_path(page_number) if @story.active?
      @page  = @story.pages.find_by(number: page_number)

    else
      @story = Story.active

      return unless assign_tagged_page(story_or_tag, page_number)
    end

    render 'show'
  end

  def read_story_tag
    unless Story.any?
      return render text: "There aren't even any stories! What?!", status: 404
    end

    story = params[:story]
    tag   = params[:tag]
    page_number = params[:page]
    story_tag_identifier = "#{story}/#{tag}"
    if page_number.nil?
        redirect_to read_story_tag_page_path(story, tag,
                                   load_cookie_for(story_tag_identifier)
                                 )
      return
    else
      store_cookie_for(story_tag_identifier, page_number)
    end

    @story = Story.find_by(link: story)

    return unless assign_tagged_page(tag, page_number)

    render 'show'
  end

  private

  def store_cookie_for(story_or_tag, page_num)
    story_or_tag = 'DEFAULT' if story_or_tag.nil?
    cookies[story_or_tag] = page_num

    puts "**************************************************************"
    puts "cookies[#{story_or_tag}] = #{page_num}"
    puts "**************************************************************"
  end

  def load_cookie_for(story_or_tag)
    story_or_tag = 'DEFAULT' if story_or_tag.nil?
    page_num = cookies[story_or_tag]

    puts "**************************************************************"
    puts "loaded cookie page num #{page_num} from #{story_or_tag}"
    puts "**************************************************************"

    return page_num.to_i if page_num && page_num.to_i != 0
    1
  end

  def assign_tagged_page(tag, page_number)
    if @story.nil?
      render text: '404', status: 404
      return false
    end

    if @story.pages.tag?(tag)
      @page = @story.pages.tagged_number(tag, page_number)
      @tag  = tag
      if @page.nil?
        render 'no_such_page', locals: { page_number: params[:page] }
        return false
      end
      # @page.scope_number_to_tag!
    else
      render_404(@story, tag)
      return false
    end
    true
  end

  # Forget about all this
  # def read(story_link)
  #   if story_link
  #     @story = case story_link
  #       when String then Story.where(link: story_link).first
  #       else story_link
  #     end

  #     # puts Story.all.map(&:link)
  #     # puts params[:story_link]

  #     @page = @story.pages.where(number: params[:page] || 1).first
  #   else
  #     if cookies[:page_id] && Page.where(id: cookies[:page_id]).exists?
  #       @page = Page.find cookies[:page_id]
  #       @story = @page.story
  #     else
  #       @story = Story.where(active: true).first || Story.order("created_at DESC").first
  #       @page = @story.first_page
  #     end
  #   end

  #   if @page.nil? || (!@page.published && !admin_signed_in?)
  #     render 'no_such_page', locals: { page_number: params[:page] }
  #   else
  #     @blog_post_ready = @page.blog_post &&
  #                        @page.blog_post.content &&
  #                       !@page.blog_post.content.empty?
  #     cookies[:page_id] = @page.id
  #     render 'show'
  #   end
  # end

  def render_404(story, tag = nil)
    return render '404', status: 404, locals: {story: story, tag: tag}
  end

  def permitted_params
    params.permit(:story_link, :page, story: [:name, :link, :active, :description])
  end
end
