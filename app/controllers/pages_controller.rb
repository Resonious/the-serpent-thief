class PagesController < InheritedResources::Base
  belongs_to :story, shallow: true
  before_filter :authenticate_admin!, except: [:show]
  after_filter :check_for_errors, only: [:create, :update]

  respond_to :html, :js

  def show
    super do |format|
      format.json do
        render json: @page
      end
      format.html do
        redirect_to read_story_page_path(@page.story.link, @page.number)
      end
    end
  end

  private

  def check_for_errors
    unless @page.valid?
      messages = @page.errors.full_messages.join(', ')
      flash[:error] = "There were issues saving the page: #{messages}"
    end
  end

  def permitted_params
    params.permit(:story_id, page: [:content, :published, tags: []])
  end
end
