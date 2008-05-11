# This is a helper for causing the contents of a column to be converted to html on save using BlueCloth.
# It assumes that there is a column with the same name as the given one but with _html appended and that
# the converted text should be stored there.
module ColumnToHtml
  def column_to_html(column_name)    
    write_inheritable_attribute :source_column_name, column_name.to_s
    class_inheritable_reader    :source_column_name
    
    before_save :convert_column_to_html
    include InstanceMethods
  end  
  
  module InstanceMethods
    def convert_column_to_html
      read_column = self.class.read_inheritable_attribute(:source_column_name)
      self[read_column + '_html'] = BlueCloth.new(self[read_column] || '').to_html
    end
  end
end