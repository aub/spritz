module Admin::AdminHelper
  def check_active_section(name)
    controller.controller_name.eql?(name) ? 'current' : ''
  end
  
  def assets_name
    'Images'
  end
  
  def asset_name
    'Image'
  end
end

