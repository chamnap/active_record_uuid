require 'spec_helper'

describe "String Uuid" do
  context "configure: Post model" do
    it "should have uuid as primary key based config" do
      Post.primary_key.should eq('uuid')
    end

    it "should store uuid as String" do
      post = Post.create(:text => "String uuid1")
      post.reload

      post.serialized_attributes['uuid'].dump(post.uuid).bytesize.should eq(36)
    end

    it "should retreive back as uuid string from String" do
      post = Post.create(:text => "String uuid2")
      post.reload

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should retreive uuid back with the same value that was assigned" do
      post = Post.new(:text => "String uuid2")
      post.uuid = "b360c78e-b62e-11e1-9870-0026b90faf3c"
      post.save
      post.reload

      post.uuid.should eq("b360c78e-b62e-11e1-9870-0026b90faf3c")
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should find by uuid column" do
      post = Post.create(:text => "String uuid3")

      Post.find_by_uuid(post.uuid).should   eq(post)
      Post.where(:uuid => post.uuid).should eq([post])
    end

    it "should find by primary key" do
      post = Post.create(:text => "String uuid4")

      Post.find(post).should eq(post)
      Post.find(post.uuid).should eq(post)
    end

    it "should find by array of primary keys" do
      post1 = Post.create(:text => "String uuid5")
      post2 = Post.create(:text => "String uuid6")

      Post.find([post1.uuid, post2.uuid]).should eq([post1, post2])
    end
  end
end
