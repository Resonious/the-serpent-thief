class TagsController < InheritedResources::Base
  respond_to :html, :js
  before_filter :authenticate_admin!

  def destroy
    super do |format|
      format.html { redirect_to :back }
      format.js { redirect_to :back }
    end
  end
end
