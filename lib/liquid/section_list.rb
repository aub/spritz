class SectionList < Liquid::Block

  @@syntax = /as\s(#{Liquid::VariableSignature}+)/
  
  def initialize(tag_name, markup, tokens)
    super
    if markup =~ @@syntax
      @as = $1
    else
      raise SyntaxError.new(
            "Syntax Error in tag 'nowreading' - Valid syntax: nowreading as [name]")
    end
  end
  
  def rlogger() RAILS_DEFAULT_LOGGER end
  
  def render(context)
    result = []
    
    site = context['site']
    sections = []
    
    sections << { 'title' => 'Links', 'url' => '/links' } if site.links.size > 0
    sections << { 'title' => 'News', 'url' => '/news' } if site.news_items.size > 0
    sections << { 'title' => 'Resume', 'url' => '/resume' } if site.resume_sections.size > 0
    sections << { 'title' => 'Galleries', 'url' => '/galleries' } if site.galleries.size > 0

    context['site'].portfolios.each { |p| sections << { 'title' => p.title, 'url' => "/portfolios/#{p.to_param}" } }
    
    sections << { 'title' => 'Contact', 'url' => '/contact/new' }
    
    sections.each_with_index do |section, index|
      context.stack do
        context['sectionlist'] = { 'index' => index + 1 }
        context[@as] = section
        result << render_all(@nodelist, context)
      end
    end
    result
  end
end

Liquid::Template.register_tag('sectionlist', SectionList)
