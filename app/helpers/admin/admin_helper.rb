module Admin::AdminHelper
  def check_active_section(name)
    controller.controller_name.eql?(name) ? 'current' : ''
  end
end

