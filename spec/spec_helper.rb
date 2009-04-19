require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'blogitr'

Spec::Runner.configure do |config|
  
end

# Load our example blog.
def example_blog
  Blogitr::Blog.new(File.join(File.dirname(__FILE__), 'blog'))
end

# We use this macro in several spec files.
class ExampleMacro < Blogitr::Macro
  def expand options, body
    "Options: #{options.inspect}\nBody: #{body}"
  end
end
Blogitr.register_macro(:example, ExampleMacro.new)
