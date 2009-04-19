require 'yaml'

module Blogitr
  # The main interface to the Blogitr module.  This class represents a
  # single blog.  Unless indicated otherwise, articles are always returned
  # in reverse-chronological order.
  class Blog
    YEAR_GLOB    = "[0-9][0-9][0-9][0-9]"  # :nodoc:
    MONTH_GLOB   = "[0-9][0-9]"            # :nodoc:
    DAY_GLOB     = "[0-9][0-9]"            # :nodoc:
    TIME_GLOB    = "[0-9][0-9][0-9][0-9]"  # :nodoc:
    ARTICLE_GLOB = "#{TIME_GLOB}-*.*[a-z]" # :nodoc: (reject "*.textile~")

    # Create a new blog object using the data stored at +root+.
    def initialize root
      @root = root
      @metadata = YAML::load(File.read(File.join(@root, 'blog.yml')))
    end

    # The title of the blog.
    def title
      @metadata['title']
    end

    # All the articles posted to the blog.
    def articles
      glob = File.join(@root, YEAR_GLOB, MONTH_GLOB, DAY_GLOB, ARTICLE_GLOB)
      Dir[glob].sort.reverse.map {|path| Blogitr::Article.new(path) }
    end
  end
end
