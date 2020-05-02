require_relative 'spec_helper'

load_extension("tracepoint")

describe "CApiTracePointSpecs" do
  before :each do
    @s = CApiTracePointSpecs.new
  end

  after :each do
    @trace.disable if @trace and @trace.enabled?
  end

  describe "rb_tracepoint_new" do
    it "returns a tracepoint object" do
      @trace = @s.rb_tracepoint_new(7)
      @trace.should be_an_instance_of(TracePoint)
      @trace.enabled?.should == false
    end

    it "traces lines when given RUBY_EVENT_LINE" do
      @trace = @s.rb_tracepoint_new(8)
      @trace.enable
      @s.callback_called?.should == 8
    end
  end

  describe "rb_tracepoint_disable" do
    it "disables an enabled TracePoint" do
      @trace = @s.rb_tracepoint_new(9)
      @trace.enabled?.should == false
      @trace.enable
      @trace.enabled?.should == true
      @s.rb_tracepoint_disable(@trace).should == false
      @trace.enabled?.should == false
    end
  end

  describe "rb_tracepoint_enable" do
    it "enables a disabled TracePoint" do
      @trace = @s.rb_tracepoint_new(10)
      @trace.enabled?.should == false
      @s.rb_tracepoint_enable(@trace).should == true
      @trace.enabled?.should == true
    end
  end

  describe "rb_tracepoint_enabled_p" do
    it "returns correct enabled status" do
      @trace = @s.rb_tracepoint_new(11)
      @s.rb_tracepoint_enabled_p(@trace).should == false
      @trace.enable
      @s.rb_tracepoint_enabled_p(@trace).should == true
    end
  end
end
