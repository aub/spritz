map.namespace(:admin) do |admin|
  admin.resources :portfolio_sections do |sections|
    sections.resources :portfolio_pages, :member => { :new => :get, :create => :post }
  end
end

map.resources :portfolio_sections do |portfolio_sections|
  portfolio_sections.resources :portfolio_pages
end