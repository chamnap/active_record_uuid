require 'spec_helper'

describe "has_uuid spec" do
  context "per model" do
    it "should have uuid as primary key based config" do
      People.primary_key.should eq('uuid')
    end

    it "should store uuid as binary" do
      person = People.create(:name => "Binary name1")
      person.reload

      person.serialized_attributes['uuid'].dump(person.uuid).bytesize.should eq(16)
    end

    it "should find by uuid column" do
      person = People.create(:name => "Binary name2")

      People.find_by_uuid(person.uuid).should   eq(person)
      People.where(:uuid => person.uuid).should eq([person])
    end
  end

  context "global" do
    before(:all) do
      ActiveRecordUuid.configure do
        column      :uuid
        primary_key true
        association false
        store_as    :binary
      end

      class PeopleBinary < ActiveRecord::Base
        self.table_name = "people"
        has_uuid :association => true
        has_many :comments
      end
    end

    it "should use global configuration" do
      PeopleBinary.uuid_config.store_as.should eq(:binary)
    end

    it "should use overwrite global configuration" do
      PeopleBinary.uuid_config.association.should eq(true)
    end

    it "should apply based on configuration" do
      PeopleBinary.reflections[:comments].options[:foreign_key].should eq("people_binary_uuid")
    end

    it "should store uuid as binary" do
      person = PeopleBinary.create!(:name => "Binary name1")
      person.reload

      person.serialized_attributes['uuid'].dump(person.uuid).bytesize.should eq(16)
    end
  end
end
