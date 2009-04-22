require 'yaml'

module Blogitr
  # This error is raised if an article does not appear to exist.
  class ArticleNotFoundError < RuntimeError
  end

  # The main interface to the Blogitr module.  This class represents a
  # single blog.  Unless indicated otherwise, articles are always returned
  # in reverse-chronological order.
  class Blog
    # Create a new blog object using the data stored at +root+.
    def initialize root
      @root = root
      @metadata = YAML::load(File.read(File.join(@root, 'blog.yml')))
    end

    # The title of the blog.
    def title() @metadata['title'] end

    # A one-line description of this blog.
    def description() @metadata['description'] end

    # All the articles posted to the blog.
    #
    # SECURITY: We should validate each of these values before checking
    # file system.  But for now, we rely on our caller to get it right.
    def articles year=nil, month=nil, day=nil, permalink=nil
      # Build a glob fragment for each of our path components.
      year_glob      = digit_glob(year, 4)
      month_glob     = digit_glob(month, 2)
      day_glob       = digit_glob(day, 2)
      hhmm_glob      = digit_glob(nil, 4)
      filter_glob    = "*[a-z0-9]" # (reject "*.textile~")
      permalink_glob = permalink || "*"

      # A poor-man's database query.
      glob = File.join(@root, year_glob, month_glob, day_glob,
                       "#{hhmm_glob}-#{permalink_glob}.#{filter_glob}")
      Dir[glob].sort.reverse.map do |path|
        relative_path = path[(@root+"/").length..-1]
        Blogitr::Article.new(:path => relative_path, :text => File.read(path))
      end
    end

    # Return the specified article, or raise ArticleNotFoundError if the
    # article does not exist.
    def article year, month, day, permalink
      result = articles(year, month, day, permalink)
      unless result.length == 1
        raise(ArticleNotFoundError,
              "Can't find #{year}/#{month}/#{day}/#{permalink}")
      end
      result[0]
    end

    private

    # If +value+ is not +nil+, convert it to a string and pad it on the
    # left with 0s until it is +digits+ characters long.  If +value+ is
    # +nil+, return a glob which matches that many digits.
    def digit_glob value, digits
      if value
        value.to_s.rjust(digits, '0')
      else
        "[0-9]" * digits
      end
    end
  end
end
