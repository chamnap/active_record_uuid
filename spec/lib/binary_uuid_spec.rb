require 'spec_helper'

describe "Binary Uuid" do
  context "configure: PostBinary model" do 
    it "should have uuid as primary key based config" do
      PostBinary.primary_key.should eq('uuid')
    end
    
    it "should have uuid association" do
      PostBinary.reflections[:comments].options[:foreign_key].should eq("post_binary_uuid")
    end
    
    it "should store uuid as binary" do
      post = PostBinary.create(:text => "Binary uuid1")
      post.reload
      
      post.attributes_before_type_cast["uuid"]["value"].bytesize.should eq(16)
    end
    
    it "should retreive back as uuid string from binary" do
      post = PostBinary.create(:text => "Binary uuid2")
      post.reload
      
      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end
    
    it "should retreive uuid back with the same value that was assigned" do
      post = PostBinary.new(:text => "Binary uuid2")
      post.uuid = "b360c78e-b62e-11e1-9870-0026b90faf3c"
      post.save
      post.reload
      
      post.uuid.should eq("b360c78e-b62e-11e1-9870-0026b90faf3c")
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end
    
    it "should find by uuid column" do
      post = PostBinary.create(:text => "Binary uuid3")

      PostBinary.find_by_uuid(post.uuid).should   eq(post)
      PostBinary.where(:uuid => post.uuid).should eq([post])
    end
    
    it "should find by primary key" do
      post = PostBinary.create(:text => "Binary uuid4")

      PostBinary.find(post).should eq(post)
      PostBinary.find(post.uuid).should eq(post)
    end
    
    it "should find by array of primary keys" do
      post1 = PostBinary.create(:text => "Binary uuid5")
      post2 = PostBinary.create(:text => "Binary uuid6")

      PostBinary.find([post1.uuid, post2.uuid]).should eq([post1, post2])
    end

    it "should save association" do
      blog = Blog.create(:name => "Blog 1")
      article = blog.articles.create(:title => "Blog Association 1")

      blog.articles.count.should eq(1)
      blog.articles[0].should eq(article)
    end
  end
end
