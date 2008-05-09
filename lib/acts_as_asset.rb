module ActsAsAsset
  def acts_as_asset
    # only need to define these once on a class
    unless included_modules.include?(InstanceMethods)
      
      before_validation_on_create :set_site_from_parent
      validate :rename_unique_filename
      
      extend  ClassMethods
      include InstanceMethods
      
      after_attachment_saved do |record|
        File.chmod 0644, record.full_filename
      end
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    # When a thumbnail is created, it needs to be given the site id from the image that contains it.
    def set_site_from_parent
      self.site_id = parent.site_id if parent_id
    end

    # Override the full_filename method from attachment_fu in order to have more control over the
    # location of the files. In this case, they are stored with a configurable root path, then the
    # site's subdomain, and then the date.
    def full_filename(thumbnail=nil)
      date = self.created_at || Time.now
      File.join(RAILS_ROOT, ASSET_PATH_ROOT, (Site.multi_sites_enabled ? self.site.subdomain : ''), 
                date.year.to_s, date.month.to_s, date.day.to_s, 
                thumbnail_name_for(thumbnail))    
    end

    # When an asset it saved, we need to make sure that there isn't already a file with that name in the
    # same directory. If there is, then append an integer to the end until we find a free file name.
    def rename_unique_filename
      if ((@old_filename && !@old_filename.eql?(full_filename)) || new_record?) && errors.empty? && site_id && filename
        i      = 1
        pieces = filename.split('.')
        ext    = pieces.size == 1 ? nil : pieces.pop
        base   = pieces * '.'
        while File.exists?(full_filename)
          write_attribute :filename, base + "_#{i}#{".#{ext}" if ext}"
          i += 1
        end
      end
    end    
  end
end
