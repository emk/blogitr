require 'spec_helper'

describe Blogitr::Article do
  before do
    @blog = example_blog
    @article = @blog.articles[0]
  end

  it "should have a title" do
    @article.title.should == 'My newest post'
  end

  it "should have a permalink" do
    @article.permalink.should == 'my-newest-post'
  end

  it "should have a date and time" do
    @article.date_time.should == DateTime.new(2009, 4, 19, 9, 47)
  end

  it "should have an author" do
    @article.author.should == 'J. Random Hacker'
  end
end
