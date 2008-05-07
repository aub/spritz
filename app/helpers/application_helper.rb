# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def asset_image_tag(asset, thumbnail = :display, options = {})
    image_tag(asset.public_filename(thumbnail), options)
  end

  #
  # This is an unholy mess.
  #

  def main_menu
    ctrlr = request.parameters['controller'].split('/').last
    dashboard_class = (ctrlr == 'dashboard' ? 'current' : '')
    assets_class = (ctrlr == 'assets' ? 'current' : '')
    design_class = ((ctrlr == 'themes' || ctrlr == 'resources') ? 'current' : '')
    contacts_class = (ctrlr == 'contacts' ? 'current' : '')
    settings_class = (ctrlr == 'settings' ? 'current' : '')
    content_class = ((ctrlr == 'home' || ctrlr == 'links' || ctrlr == 'news_items' || ctrlr == 'portfolios') ? 'current' : '')
    
    result =  content_tag('li', link_to('Dashboard', admin_dashboard_path, :class => dashboard_class))
    result << content_tag('li', link_to('Content', edit_admin_home_path, :class => content_class))
    result << content_tag('li', link_to(assets_name, admin_assets_path, :class => assets_class))
    result << content_tag('li', link_to('Design', admin_themes_path, :class => design_class))
    result << content_tag('li', link_to('Contacts', admin_contacts_path, :class => contacts_class))
    result << content_tag('li', link_to('Settings', edit_admin_settings_path, :class => settings_class))
  end
  
  def submenu
    content_submenu << design_submenu
  end
  
  def content_submenu
    ctrlr = request.parameters['controller'].split('/').last
    if (ctrlr == 'home' || ctrlr == 'links' || ctrlr == 'news_items' || ctrlr == 'portfolios')
      home_class = (ctrlr == 'home' ? 'current' : '')
      links_class = (ctrlr == 'links' ? 'current' : '')
      news_class = (ctrlr == 'news_items' ? 'current' : '')
      portfolios_class = (ctrlr == 'portfolios' ? 'current' : '')
    
      content_for :subcontrols do
        result = content_tag('li', link_to('Home', edit_admin_home_path, :class => home_class))
        result << content_tag('li', link_to('Links', admin_links_path, :class => links_class))
        result << content_tag('li', link_to('News', admin_news_items_path, :class => news_class))
        result << content_tag('li', link_to('Portfolios', admin_portfolios_path, :class => portfolios_class))
      end
    else
      ''
    end
  end
  
  def design_submenu
    ctrlr = request.parameters['controller'].split('/').last
    if (ctrlr == 'themes' || ctrlr == 'resources')
      theme_class = (ctrlr == 'themes' ? 'current' : '')
      editor_class = (ctrlr == 'resources' ? 'current' : '') 
      content_for :subcontrols do
        result =  content_tag('li', link_to('Themes', admin_themes_path, :class => theme_class))
        result << content_tag('li', link_to('Theme Editor', admin_resources_path, :class => editor_class))
      end
    else
      ''
    end
  end
end
