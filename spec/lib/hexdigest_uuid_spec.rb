require 'spec_helper'

describe "HexDigest Uuid" do
  context "configure: PostHexDigest model" do
    it "should have uuid as primary key based config" do
      PostHexDigest.primary_key.should eq('uuid')
    end

    it "should store uuid as HexDigest" do
      post = PostHexDigest.create(:text => "HexDigest uuid1")
      post.reload

      PostHexDigest.serialized_attributes['uuid'].dump(post.uuid).bytesize.should eq(32)
    end

    it "should retreive back as uuid string from HexDigest" do
      post = PostHexDigest.create(:text => "HexDigest uuid2")
      post.reload

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should retreive uuid back with the same value that was assigned" do
      post = PostHexDigest.new(:text => "HexDigest uuid2")
      post.uuid = "b360c78e-b62e-11e1-9870-0026b90faf3c"
      post.save
      post.reload

      post.uuid.should eq("b360c78e-b62e-11e1-9870-0026b90faf3c")
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should find by uuid column" do
      post = PostHexDigest.create(:text => "HexDigest uuid3")

      PostHexDigest.find_by_uuid(post.uuid).should   eq(post)
      PostHexDigest.where(:uuid => post.uuid).should eq([post])
    end

    it "should find by primary key" do
      post = PostHexDigest.create(:text => "HexDigest uuid4")

      PostHexDigest.find(post).should eq(post)
      PostHexDigest.find(post.uuid).should eq(post)
    end

    it "should find by array of primary keys" do
      post1 = PostHexDigest.create(:text => "HexDigest uuid5")
      post2 = PostHexDigest.create(:text => "HexDigest uuid6")

      PostHexDigest.find([post1.uuid, post2.uuid]).should eq([post1, post2])
    end
  end
end
