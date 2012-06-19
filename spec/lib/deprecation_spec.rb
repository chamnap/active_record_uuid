require 'spec_helper'

describe "Depreciation: ActiveRecord::UuidBase" do
	it "should create uuid" do
		article = ArticleUuidBase.create(:title => "uuid base1")

		article.uuid.length.should eq(36)
	end

	it "should not use primary_key" do
    ArticleUuidBase.primary_key.should eq("uuid")
  end
  
  it "should not set association" do
    ArticleUuidBase.reflections[:comments].options[:foreign_key].should eq("article_uuid_base_uuid")
  end
end