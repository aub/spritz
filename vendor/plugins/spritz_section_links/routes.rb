map.namespace(:admin) do |admin|
  admin.resources :link_sections do |sections|
    sections.resources :links
  end
end
