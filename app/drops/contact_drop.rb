class ContactDrop < BaseDrop
  liquid_attributes << :name << :email << :phone << :message
  
  def errors
    unless source.valid?
      # Because the error object will ignore our message and prepend the field name anyway.
      source.errors.collect { |error| error[1] }
    end
  end
end