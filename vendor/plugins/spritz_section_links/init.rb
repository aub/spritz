# This is required because the plugin is going to make a subclass of the section and
# if this isn't here then we will get two different section class types. Probably should
# move it so that it gets required before plugins are loaded in automatically.
require 'section'

add_section_type(LinkSection)
