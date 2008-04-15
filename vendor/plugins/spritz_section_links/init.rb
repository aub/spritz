# This is required in each plugin of this type in order to make it reload correctly
# in development mode. See: http://www.ruby-forum.com/topic/137733
load_paths.each do |path|
  Dependencies.load_once_paths.delete(path)
end

# This is required because the plugin is going to make a subclass of the section and
# if this isn't here then we will get two different section class types. Probably should
# move it so that it gets required before plugins are loaded in automatically.
require 'section'

Spritz::Plugin.add_section_type(LinkSection)
