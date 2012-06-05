require 'spec_helper'

describe "UuidBase" do
  context "uuid as primary key" do
    it "should have uuid as primary key for new models" do
      class NewPostInherit < ActiveRecord::UuidBase
        self.table_name = "posts"
      end
      NewPostInherit.primary_key.should eq('uuid')
    end

    it "should have uuid as primary key for existing models" do
      PostInherit.primary_key.should eq('uuid')
    end

    it "should assign uuid automatically when create new record" do
      post = PostInherit.create(:text => "Auto Generate uuid")
      post.reload

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should assign uuid manually" do
      post = PostInherit.new(:text => "Manual uuid")
      post.uuid = "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
      post.save
      post.reload

      post.uuid.should eq("79f8a42e-ae60-11e1-9aa9-0026b90faf3c")
    end

    it "should assign uuid if blank" do
      post = PostInherit.new(:text => "Manual uuid 2")
      post.assign_uuid

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should assign uuid if blank and save immediately" do
      post = PostInherit.new(:text => "Manual uuid 3")
      post.assign_uuid!

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should have valid uuid" do
      post = PostInherit.new(:text => "Invalid uuid")
      post.uuid = "invalid"

      post.valid?.should eq(false)
      post.errors[:uuid].first.should eq("is invalid")
    end
    
    it "should generate uuid" do
      uuid = PostInherit.generate_uuid
      
      uuid.should be_present
      uuid.should be_instance_of(String)
      uuid.length.should eq(36)
    end
  end
  
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
