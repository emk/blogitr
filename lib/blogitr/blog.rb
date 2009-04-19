require 'yaml'

module Blogitr
  # The main interface to the Blogitr module.  This class represents a
  # single blog.
  class Blog
    # Create a new blog object using the data stored at +root+.
    def initialize root
      @metadata = YAML::load(File.read(File.join(root, 'blog.yml')))
    end

    # The title of the blog.
    def title
      @metadata['title']
    end
  end
end
