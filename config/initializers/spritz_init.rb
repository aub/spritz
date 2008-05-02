require 'liquid/initializer'
require 'acts_as_asset'

ActiveRecord::Base.send(:extend, ActsAsAsset)
