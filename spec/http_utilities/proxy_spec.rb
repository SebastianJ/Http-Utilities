require File.expand_path('../../spec_helper', __FILE__)

describe Proxy do

  describe "when initialized" do
    before(:each) do
      clean_database!
      @proxy = Proxy.new
    end
    
    it "should respond to proxy address module instance method" do
      @proxy.should respond_to(:proxy_address)
    end
    
    it "should correctly return a formatted proxy address" do
      @proxy.host = "127.0.0.1"
      @proxy.port = 80
      
      @proxy.proxy_address.should == "127.0.0.1:80"
      @proxy.proxy_address(include_http = true).should == "http://127.0.0.1:80"
    end
  end
  
  describe "in a class context" do
    it "should respond to get random proxy module class method" do
      Proxy.should respond_to(:get_random_proxy)
    end
    
    it "should respond to format proxy address module class method" do
      Proxy.should respond_to(:format_proxy_address)
    end
    
    it "should respond to format proxy credentials module class method" do
      Proxy.should respond_to(:format_proxy_credentials)
    end
    
    it "should respond to should_be_checked-scope" do
      Proxy.should respond_to(:should_be_checked)
    end
  end
  
end