module Blogitr
  # An article on the blog.
  class Article < Document
    # The short form of the permalink.  This will typically be combined
    # with the site name and a directory to generate the full permalink.
    attr_reader :permalink

    # The date and time this article was published, relative to the blog's
    # time zone at the time of publication.  We don't use GMT here, because
    # we want article URLs to remain stable even when the blog changes time
    # zones.  More accurate publication times should eventually be
    # available through git.
    attr_reader :date_time

    # Create a new article.
    def initialize opts
      pattern =
        /\A(\d{4})\/(\d{2})\/(\d{2})\/(\d{2})(\d{2})-([^.]+)\.([a-z0-9]+)\z/
      opts[:path] =~ pattern or
        raise "Invalid article path: #{opts[:path]}"
      @date_time = DateTime.new($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i)
      @permalink = $6
      super(:text => opts[:text], :filter => $7.to_sym)
    end

    # The human-readable title of this article.
    def title
      headers['title']
    end
  end
end
