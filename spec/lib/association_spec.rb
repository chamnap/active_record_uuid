require 'spec_helper'

describe "UuidConfig" do
  context "uuid association" do
    before(:all) do
      @post1 = Post.create!(:text => "Post 1")
      @post2 = Post.create!(:text => "Post 2")
      @comment1 = Comment.create!(:text => "Comment 1", :post_uuid => @post1.uuid)
      @comment2 = Comment.create!(:text => "Comment 2", :post_uuid => @post1.uuid)
      
      @author = Author.create!(:name => "Chamnap")
    end
    
    it "should retreive has_many relation" do
      @post1.comments.count.should eq(2)
    end
    
    it "should retreive has_one relation" do
      @post1.comment.should be_instance_of(Comment)
    end
    
    it "should retreive belongs_to relation" do
      @comment1.post.text.should eq(@post1.text)
    end
    
    it "should retreive has_and_belongs_to_many relation from post" do
      @post1.authors << @author
      
      @post1.authors.count.should eq(1)
      @post1.authors.should include(@author)
    end
    
    it "should retreive has_and_belongs_to_many relation from author" do
      @author.posts << @post2
      
      @author.posts.count.should eq(2)
      @author.posts.should include(@post2)
    end
  end
end
