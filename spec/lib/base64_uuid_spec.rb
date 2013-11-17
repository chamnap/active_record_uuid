require 'spec_helper'

describe "Base64 Uuid" do
  context "configure: PostBase64 model" do
    it "should have uuid as primary key based config" do
      PostBase64.primary_key.should eq('uuid')
    end

    it "should store uuid as base64" do
      post = PostBase64.create(:text => "Base64 uuid1")
      post.reload

      post.serialized_attributes['uuid'].dump(post.uuid).bytesize.should eq(24)
    end

    it "should retreive back as uuid string from base64" do
      post = PostBase64.create(:text => "Base64 uuid2")
      post.reload

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should retreive uuid back with the same value that was assigned" do
      post = PostBase64.new(:text => "Base64 uuid2")
      post.uuid = "b360c78e-b62e-11e1-9870-0026b90faf3c"
      post.save
      post.reload

      post.uuid.should eq("b360c78e-b62e-11e1-9870-0026b90faf3c")
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should find by uuid column" do
      post = PostBase64.create(:text => "Base64 uuid3")

      PostBase64.find_by_uuid(post.uuid).should   eq(post)
      PostBase64.where(:uuid => post.uuid).should eq([post])
    end

    it "should find by primary key" do
      post = PostBase64.create(:text => "Base64 uuid4")

      PostBase64.find(post).should eq(post)
      PostBase64.find(post.uuid).should eq(post)
    end

    it "should find by array of primary keys" do
      post1 = PostBase64.create(:text => "Base64 uuid5")
      post2 = PostBase64.create(:text => "Base64 uuid6")

      PostBase64.find([post1.uuid, post2.uuid]).should eq([post1, post2])
    end
  end
end
