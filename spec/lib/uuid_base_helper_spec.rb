require 'spec_helper'

describe "UuidBaseHelper" do
  context "uuid as primary key" do
    it "should have uuid as primary key for new models" do
      class NewPostInclude < ActiveRecord::Base
        include UuidBaseHelper
        self.table_name = "posts"
      end
      NewPostInclude.primary_key.should eq('uuid')
    end

    it "should have uuid as primary key for existing models" do
      PostInclude.primary_key.should eq('uuid')
    end

    it "should assign uuid automatically when create new record" do
      post = PostInclude.create(:text => "Auto Generate uuid")
      post.reload

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should assign uuid manually" do
      post = PostInclude.new(:text => "Manual uuid")
      post.uuid = "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
      post.save
      post.reload

      post.uuid.should eq("79f8a42e-ae60-11e1-9aa9-0026b90faf3c")
    end

    it "should assign uuid if blank" do
      post = PostInclude.new(:text => "Manual uuid 2")
      post.assign_uuid

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should assign uuid if blank and save immediately" do
      post = PostInclude.new(:text => "Manual uuid 3")
      post.assign_uuid!

      post.uuid.should be_present
      post.uuid.should be_instance_of(String)
      post.uuid.length.should eq(36)
    end

    it "should have valid uuid" do
      post = PostInclude.new(:text => "Invalid uuid")
      post.uuid = "invalid"

      post.valid?.should eq(false)
      post.errors[:uuid].first.should eq("is invalid")
    end
    
    it "should generate uuid" do
      uuid = PostInclude.generate_uuid
      
      uuid.should be_present
      uuid.should be_instance_of(String)
      uuid.length.should eq(36)
    end
  end
end
