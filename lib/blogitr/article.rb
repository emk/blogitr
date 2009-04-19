module Blogitr
  # An article on the blog.
  class Article < Document
    # The short form of the permalink.  This will typically be combined
    # with the site name and a directory to generate the full permalink.
    attr_reader :permalink

    # Create a new article.
    def initialize opts
      pattern = /\A(\d{4})\/(\d{2})\/(\d{2})\/(\d{4})-([^.]+)\.([a-z0-9]+)\z/
      opts[:path] =~ pattern or
        raise "Invalid article path: #{opts[:path]}"
      @permalink = $5
      super(:text => opts[:text], :filter => $6.to_sym)
    end

    # The human-readable title of this article.
    def title
      headers['title']
    end
  end
end
