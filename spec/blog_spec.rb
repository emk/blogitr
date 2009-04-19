require 'spec_helper'

describe Blogitr::Blog do
  before do
    @blog = Blogitr::Blog.new(File.join(File.dirname(__FILE__), 'blog'))
  end

  it "should have a title" do
    @blog.title.should == "My blog"
  end

  it "should return articles in reverse-chronological order" do
    articles = @blog.articles
    articles[0].title.should == "My newest post"
    articles[1].title.should == "My second-newest post"
  end
end
