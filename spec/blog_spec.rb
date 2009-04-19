require 'spec_helper'

describe Blogitr::Blog do
  before do
    @blog = Blogitr::Blog.new(File.join(File.dirname(__FILE__), 'blog'))
  end

  it "should have a title" do
    @blog.title.should == "My blog"
  end
end
