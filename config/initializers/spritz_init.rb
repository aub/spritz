require 'liquid/initializer'
require 'acts_as_asset'
require 'column_to_html'
require 'will_paginate'

ActiveRecord::Base.send(:extend, ActsAsAsset)
ActiveRecord::Base.send(:extend, ColumnToHtml)

Dependencies.autoloaded_constants.delete "Spritz"