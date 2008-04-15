module Spritz
  module Plugin
    @@section_types = []
    mattr_reader :section_types
    
    # Add a section type to the list of available types. This method can be called in
    # the init.rb file of an individual plugin, and while it is not limited to one per
    # plugin, that would be the ideal. The value passed in should be the actual type
    # of the object that will represent this section. In addition, the class should implement
    # the following methods:
    #
    # name -             So the app can get the name to present in the UI.
    #
    # admin_controller - The controller that will handle calls for this section. It should be
    #                    implemented in the app/controllers directory of your plugin, following the 
    #                    engines conventions, and it is assumed to be RESTful. Routes for this controller
    #                    should be added through the routes.rb file in the root directory of the plugin.
    #                    The controller should be a subclass of Admin::AdminController so that it will
    #                    use the proper filters and so that calls will be specific to the appropriate site. 
    #                    This method should return a string like 'admin/links_controller'.
    #
    # singleton? -       This method should return true if there is only allowed to be one of this
    #                    section type for each site. Not implementing it is the same as returning false.
    #
    # initialize_site -  Will be called when creating new sites, passing the site. The idea is that if
    #                    new sites should be initialized with an instance of this section then the plugin
    #                    can create it automatically. Not implementing it is the same as doing nothing.
    #
    # handle_request -   This method will be called by the dispatcher in order to render data from
    #                    the section. If it is implemented, it should take a request as its parameter
    #                    and return either: a) nil if it doesn't handle the request, or b) an array
    #                    with two items if it does handle the request. The returned array should have
    #                    the name of the template to be rendered as its first entry and a hash of variables
    #                    to assign as the second (i.e. { :links => [link1, link2]}). If a non-null value
    #                    is returned, request processing will be halted and the given template will be
    #                    rendered with the given variables assigned.
    #
    # Example:
    #
    # class LinkSection < Section
    #   @@name = 'Links'
    #   @@admin_controller = 'admin/link_sections'
    #   cattr_accessor :name, :admin_controller
    # end
    #
    # and in init.rb...
    #
    # add_section_type(LinkSection)
    #
    def add_section_type(section_type)
      @@section_types << section_type
    end
  end
end

Engines::Plugin.send :include, Spritz::Plugin