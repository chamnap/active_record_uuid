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
end
