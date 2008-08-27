require 'liquid/initializer'
require 'acts_as_reorderable'
require 'column_to_html'
require 'will_paginate'

ActiveRecord::Base.send(:extend, ActsAsReorderable)
ActiveRecord::Base.send(:extend, ColumnToHtml)

Dependencies.autoloaded_constants.delete "Spritz"
