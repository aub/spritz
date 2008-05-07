# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def asset_image_tag(asset, thumbnail = :display, options = {})
    image_tag(asset.public_filename(thumbnail), options)
  end

  def main_menu
    ctrlr = request.parameters['controller']
    dashboard_class = (ctrlr == 'admin/dashboard' ? 'current' : '')
    home_class = (ctrlr == 'admin/home' ? 'current' : '')
    links_class = (ctrlr == 'admin/links' ? 'current' : '')
    news_class = (ctrlr == 'admin/news_items' ? 'current' : '')
    portfolios_class = (ctrlr == 'admin/portfolios' ? 'current' : '')
    assets_class = (ctrlr == 'admin/assets' ? 'current' : '')
    design_class = ((ctrlr == 'admin/themes' || ctrlr == 'admin/resources') ? 'current' : '')
    contacts_class = (ctrlr == 'admin/contacts' ? 'current' : '')
    settings_class = (ctrlr == 'admin/settings' ? 'current' : '')
    
    result =  content_tag('li', link_to('Dashboard', dashboard_path, :class => dashboard_class))
    result << content_tag('li', link_to('Home', edit_admin_home_path, :class => home_class))
    result << content_tag('li', link_to('Links', admin_links_path, :class => links_class))
    result << content_tag('li', link_to('News', admin_news_items_path, :class => news_class))
    result << content_tag('li', link_to('Portfolios', admin_portfolios_path, :class => portfolios_class))
    result << content_tag('li', link_to(assets_name, admin_assets_path, :class => assets_class))
    result << content_tag('li', link_to('Design', admin_themes_path, :class => design_class))
    result << content_tag('li', link_to('Contacts', admin_contacts_path, :class => contacts_class))
    result << content_tag('li', link_to('Settings', edit_admin_settings_path, :class => settings_class))
  end
  
  def design_submenu
    ctrlr = request.parameters['controller']
    theme_class = (ctrlr == 'admin/themes' ? 'current' : '')
    editor_class = (ctrlr == 'admin/resources' ? 'current' : '') 
    content_for :subcontrols do
      result =  content_tag('li', link_to('Themes', admin_themes_path, :class => theme_class))
      result << content_tag('li', link_to('Theme Editor', admin_resources_path, :class => editor_class))
    end
    ''
  end
end
