class WebpagesController < InheritedResources::Base
  before_filter :authenticate_admin!, except: [:index, :show]

  def index
    redirect_to stories_path
  end

  def show
    if path = params[:webpage_path]
      @webpage = Webpage.find_by(path: "/#{path}")
    else
      @webpage = Webpage.find_by(id: params[:id])
    end

    if @webpage.nil?
      render inline: "404 page not found", status: 404
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def create
    super do |success, failure|
      success.html { redirect_to @webpage.path }
      failure.html { render 'new' }
    end
  end

  def update
    super do |success, failure|
      success.html { redirect_to @webpage.path }
      failure.html { render 'edit' }
    end
  end

  protected

  def webpage_params
    params.require(:webpage).permit(:name, :path, :content, :show_link)
  end
end