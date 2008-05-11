require 'liquid/initializer'
require 'acts_as_asset'
require 'column_to_html'

ActiveRecord::Base.send(:extend, ActsAsAsset)
ActiveRecord::Base.send(:extend, ColumnToHtml)