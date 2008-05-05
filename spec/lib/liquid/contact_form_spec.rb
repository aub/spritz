require File.dirname(__FILE__) + '/../../spec_helper'

describe ContactForm do
  define_models :contact_form
  
  before(:each) do
    @contact = Contact.new(:email => 'a@b.com', :name => 'Aubrey')
    @arg = { 'contact' => @contact }
  end
  
  it "should register itself as a liquid tag" do
    Liquid::Template.tags['contactform'].should == ContactForm
  end
  
  it "should require the tag to be closed" do
    lambda { render_liquid('{% contactform %}') }.should raise_error(SyntaxError)
  end
  
  it "should render the base form correctly" do
    render_liquid('{% contactform %} {% endcontactform %}', nil, @arg).should == "<form id=\"contact-form\" method=\"post\" action=\"/contact\"> </form>"
  end
  
  it "should render a message if it is provided" do
    render_liquid('{% contactform %} {% endcontactform %}', nil, @arg.merge({'message' => 'HEYA'})).should == "<p id=\"contact-flash\">HEYA</p><form id=\"contact-form\" method=\"post\" action=\"/contact\"> </form>"
  end
  
  it "should render the name input" do
    render_liquid('{% contactform %}{{ form.name }}{% endcontactform %}').should be_include("<input type=\"text\" id=\"contact-name\" name=\"contact[name]\" value=\"\"/>")
  end

  it "should render the name input with value" do
    @contact.name = 'HEYA'
    render_liquid('{% contactform %}{{ form.name }}{% endcontactform %}', nil, @arg).should be_include("<input type=\"text\" id=\"contact-name\" name=\"contact[name]\" value=\"HEYA\"/>")
  end
  
  it "should render the email input" do
    @contact.email = 'HEYA'
    render_liquid('{% contactform %}{{ form.email }}{% endcontactform %}', nil, @arg).should be_include("<input type=\"text\" id=\"contact-email\" name=\"contact[email]\" value=\"HEYA\"/>")
  end
  
  it "should render the phone input" do
    @contact.phone = 'HEYA'
    render_liquid('{% contactform %}{{ form.phone }}{% endcontactform %}', nil, @arg).should be_include("<input type=\"text\" id=\"contact-phone\" name=\"contact[phone]\" value=\"HEYA\"/>")
  end

  it "should render the message input" do
    @contact.message = 'HEYA'
    render_liquid('{% contactform %}{{ form.message }}{% endcontactform %}', nil, @arg).should be_include("<textarea id=\"contact-message\" name=\"contact[message]\" rows=\"6\" cols=\"40\">HEYA</textarea>")
  end
  
  it "should render a submit button" do
    render_liquid('{% contactform %}{{ form.submit }}{% endcontactform %}', nil, @arg).should be_include("<input type=\"submit\" class=\"submit\" value=\"Send\" />")
  end  
end
