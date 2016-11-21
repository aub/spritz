class ContactForm < ::Liquid::Block

  def rlogger() RAILS_DEFAULT_LOGGER end

  def render(context)
    result = []
    context.stack do
            
      contact = context['contact']
      
      values = {}
      ['name', 'email', 'phone', 'message'].each { |v| values[v] = CGI::escapeHTML(contact[v]) } unless contact.nil?
    
      context['form'] = {
        'name'    => %(<input type="text" id="contact-name" name="contact[name]" value="#{values['name']}"/>),
        'email'   => %(<input type="text" id="contact-email" name="contact[email]" value="#{values['email']}"/>),
        'phone'   => %(<input type="text" id="contact-phone" name="contact[phone]" value="#{values['phone']}"/>),
        'message' => %(<textarea id="contact-message" name="contact[message]" rows="6" cols="40">#{values['message']}</textarea>),
        'submit'  => %(<input type="submit" class="submit" value="Send" />)
      }
      
      errors = contact.errors.blank? ? '' : %Q{<ul id="contact-errors"><li>#{contact.errors.join('</li><li>')}</li></ul>} unless contact.nil?
      
      message = context['message'].blank? ? '' : %(<p id="contact-flash">#{context['message']}</p>)
      
      result << %(#{message}#{errors}<form id="contact-form" method="post" action="/contact">#{render_all(@nodelist, context)}</form>)
    end
    result
  end
end

Liquid::Template.register_tag('contactform', ContactForm)
