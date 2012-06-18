require 'spec_helper'

describe "Uuid Config" do
  it "should initialize with default values" do
    @config = ActiveRecordUuid::Config.new
    
    @config.column.should eq(:uuid)
    @config.primary_key.should eq(false)
    @config.association.should eq(false)
    @config.generator.should eq(:timestamp)
    @config.store_as.should eq(:string)
    @config.hook.should eq(:before_validation)
  end
  
  it "should validate options: generator" do
    @config = ActiveRecordUuid::Config.new
    
    @config.generator(:abc)
    lambda {
      @config.validate_options!
    }.should raise_error ArgumentError, /^Expected :timestamp/
  end
  
  it "should validate options: store_as" do
    @config = ActiveRecordUuid::Config.new
    
    @config.store_as(:abc)
    lambda {
      @config.validate_options!
    }.should raise_error ArgumentError, /^Expected :binary/
  end
  
  it "should validate options: hook" do
    @config = ActiveRecordUuid::Config.new
    
    @config.hook(:abc)
    lambda { 
      @config.validate_options!
    }.should raise_error ArgumentError, /^Expected :before_validation/
  end
end
