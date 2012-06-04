require 'spec_helper'

describe "active_record_uuid" do
  context "uuid as primary key" do
    it "should have uuid as primary key for existing models" do
      Post.primary_key.should eq('uuid')
    end

    it "should have uuid as primary key for new models" do
    	class NewPost < ActiveRecord::UuidBase
    		self.table_name = "posts"
    	end
      NewPost.primary_key.should eq('uuid')
    end

    it "should assign inheritance_column to 'ruby_type'" do
    	Post.inheritance_column.should eq('ruby_type')
    end

    it "should be able to overwrite inheritance_column" do
    	Post.class_eval do
    		self.inheritance_column = 'type'
    	end

    	Post.inheritance_column.should eq('type')
    end

    it "should assign uuid automatically when create new record" do
    	post = Post.create(:text => "Auto Generate uuid")
    	post.reload

    	post.uuid.should be_present
    	post.uuid.should be_instance_of(String)
    	post.uuid.length.should eq(36)
    end

    it "should assign uuid manually" do
    	post = Post.new(:text => "Manual uuid")
    	post.uuid = "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
    	post.save
    	post.reload

    	post.uuid.should eq("79f8a42e-ae60-11e1-9aa9-0026b90faf3c")
    end

    it "should assign uuid if blank" do
    	post = Post.new(:text => "Manual uuid 2")
    	post.assign_uuid

    	post.uuid.should be_present
    	post.uuid.should be_instance_of(String)
    	post.uuid.length.should eq(36)
    end

    it "should assign uuid if blank and save immediately" do
    	post = Post.new(:text => "Manual uuid 3")
    	post.assign_uuid!

    	post.uuid.should be_present
    	post.uuid.should be_instance_of(String)
    	post.uuid.length.should eq(36)
    end

    it "should have valid uuid" do
    	post = Post.new(:text => "Invalid uuid")
    	post.uuid = "invalid"

    	post.valid?.should eq(false)
	    post.errors[:uuid].first.should eq("is invalid")
    end
  end
end
