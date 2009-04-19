module Blogitr
  # An article on the blog.
  class Article < Document
    
    # Load the article located at +path+.
    def initialize path
      path =~ /\.([a-z]+)\z/ or raise "Invalid article path: #{path}"
      super(:text => File.read(path), :filter => $1.to_sym)
    end

    # The human-readable title of this article.
    def title
      headers['title']
    end
  end
end
