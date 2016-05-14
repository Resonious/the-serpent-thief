class BlogPost < ActiveRecord::Base
  include Content

  belongs_to :page
end
