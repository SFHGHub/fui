require 'spec_helper'

describe Fui::Finder do
  before :each do
    @fixtures_dir = File.expand_path(File.join(__FILE__, '../../fixtures'))
  end
  describe "#find" do
    it "finds all files for which the block yields true" do
      files = Fui::Finder.send(:find, @fixtures_dir) do |file|
        File.extname(file) == ".h"
      end
      files.should eq Dir["#{@fixtures_dir}/*.h"]
    end
  end
  describe "#headers" do
    it "finds all headers" do
      finder = Fui::Finder.new(@fixtures_dir)
      finder.headers.map { |h| h.filename }.should == ["unused_class.h", "used_class.h"]
    end
  end
  describe "#references" do
    it "maps references" do
      finder = Fui::Finder.new(@fixtures_dir)
      finder.references.size.should == 2
      Hash[finder.references.map { |k, v| [ k.filename,  v.count ]}].should == {
        "unused_class.h" => 0,
        "used_class.h" => 1
      }
    end
  end
  describe "#unsed_references" do
    it "finds unused references" do
      finder = Fui::Finder.new(@fixtures_dir)
      Hash[finder.unused_references.map { |k, v| [ k.filename,  v.count ]}].should == {
        "unused_class.h" => 0
      }
    end
  end
end
