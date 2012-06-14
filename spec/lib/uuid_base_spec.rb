require 'spec_helper'

describe "UuidBase" do
  context "uuid base configuration - default option" do
    it "should not use primary_key" do
      Article.primary_key.should eq("id")
    end
    
    it "should not set association" do
      Article.reflections[:comments].options[:foreign_key].should be(nil)
    end
    
    it "should generate uuid string on uuid column" do
      article = Article.create(:title => "Hello World")
      
      article.uuid_valid?.should be_true
    end
  end
  
  context "generate and validate uuid" do
    it "should validate duplicate uuid" do
      article1 = Article.create(:uuid => '8df4689b-b580-11e1-9d31-0026b90faf3c', :title => "Hello World1")
      article2 = Article.new(:uuid => '8df4689b-b580-11e1-9d31-0026b90faf3c', :title => "Hello World2")
      
      article2.valid?.should be_false
      article2.errors[:uuid].first.should be_include("been taken")
    end
    
    it "should assign uuid manually" do
      article = Article.new(:title => "Manual uuid")
      article.uuid = "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
      article.save
      article.reload

      article.uuid.should eq("79f8a42e-ae60-11e1-9aa9-0026b90faf3c")
    end
    
    it "should assign uuid if blank" do
      article = Article.new(:title => "Manual uuid 2")
      article.assign_uuid

      article.uuid.should be_present
      article.uuid_valid?.should be_true
    end

    it "should assign uuid if blank and save immediately" do
      article = Article.new(:title => "Manual uuid 3")
      article.assign_uuid!

      article.uuid.should be_present
      article.uuid_valid?.should be_true
    end

    it "should have valid uuid" do
      article = Article.new(:title => "Invalid uuid")
      article.uuid = "invalid"

      article.valid?.should eq(false)
      article.errors[:uuid].first.should be_include("is invalid")
    end
    
    it "should generate uuid" do
      uuid = Article.generate_uuid
      
      uuid.should be_present
      uuid.should be_instance_of(String)
      uuid.length.should eq(36)
    end
  end

  context "configure: PostBinary model" do 
    it "should have uuid as primary key based config" do
      PostBinary.primary_key.should eq('uuid')
    end
    
    it "should have uuid association" do
      PostBinary.reflections[:comments].options[:foreign_key].should eq("post_binary_uuid")
    end
    
    it "should store uuid as binary" do
      post = PostBinary.create(:text => "Binary uuid1")
      
      ActiveRecord::Base.connection.execute("select uuid from post_binaries where text = 'Binary uuid1'")[0]["uuid"].bytesize.should eq(16)
    end
    
    it "should retreive back as uuid string from binary" do
      post = PostBinary.create(:text => "Binary uuid2")
#      post.reload
      
      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end
    
    it "should retreive uuid back with the same value that was assigned" do
      post = PostBinary.new(:text => "Binary uuid2")
      post.uuid = "b360c78e-b62e-11e1-9870-0026b90faf3c"
      post.save
#      post.reload
      
      post.uuid.should eq("b360c78e-b62e-11e1-9870-0026b90faf3c")
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end
  end
end
