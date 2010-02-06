require File.dirname(__FILE__) + '/../spec_helper'

describe "Tagger" do
  before(:each) do
    [TaggableModel, Tag, Tagging, TaggableUser].each(&:delete_all)
    @user = TaggableUser.new
    @taggable = TaggableModel.new(:name => "Bob Jones")
  end

  it "should have taggings" do
    @user.tag(@taggable, :with=>'ruby,scheme', :on=>:tags)
    @user.owned_taggings.size == 2
  end

  it "should have tags" do
    @user.tag(@taggable, :with=>'ruby,scheme', :on=>:tags)
    @user.owned_tags.size == 2
  end
  
  it "should not overlap or lose tags from different users" do
    @user2 = TaggableUser.new
    lambda{
      @user.tag(@taggable, :with => 'ruby, scheme', :on => :tags)
      @user2.tag(@taggable, :with => 'java, python, lisp, ruby', :on => :tags)
    }.should change(Tagging, :count).by(6)

    @user.owned_tags.map(&:name).should == %w(ruby scheme)
    @user2.owned_tags.map(&:name).sort.should == %w(java python lisp ruby).sort
    @taggable.tags_from(@user).should == %w(ruby scheme)
    @taggable.tags_from(@user2).should == %w(java python lisp ruby)
    @taggable.all_tags_list_on(:tags).sort.should == %w(ruby scheme java python lisp).sort
    @taggable.all_tags_on(:tags).size.should == 6
  end

  it "is tagger" do
    @user.is_tagger?.should(be_true)
  end  
end