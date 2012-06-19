require 'spec_helper'

describe "Serializer" do
  it "should raise exception when loading invalid uuid" do
    @serializer = ActiveRecordUuid::Serializer.new(:binary)

    lambda {
      @serializer.load("abkc")
    }.should raise_error ActiveRecord::SerializationTypeMismatch
  end
end