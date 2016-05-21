class Webpage < ActiveRecord::Base
  include Content

  scope :with_links, -> { where(show_link: true) }

  validates_presence_of :content

  before_save :format_path
  after_save :recache

  class << self
    attr_reader :path_cache
    @path_cache = nil

    def recache
      if @path_cache
        @path_cache.clear
      else
        @path_cache = ThreadSafe::Cache.new
      end

      pluck(:path).each { |path| @path_cache[path] = true }
    end

    def check(path)
      recache if @path_cache.nil? || Rails.env.development?
      @path_cache.key?(path)
    end
  end

  def recache
    self.class.recache
  end

  def format_path
    if path[0] != '/'
      self.path = path.prepend '/'
    end
    self.path = path
      .gsub(/\/\/+/, '/')
      .gsub(/\\+/, '/')
      .gsub(/\s/, '-')
  end
end