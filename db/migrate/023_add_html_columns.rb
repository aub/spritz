class AddHtmlColumns < ActiveRecord::Migration
  class Portfolio < ActiveRecord::Base; end
  class NewsItem < ActiveRecord::Base; end
  class Site < ActiveRecord::Base; end
  
  def self.up
    add_column :portfolios, :body_html, :text
    add_column :news_items, :text_html, :text
    add_column :sites, :home_text_html, :text
    
    Portfolio.transaction do
      Portfolio.find(:all).each do |portfolio|
        portfolio.update_attribute(:body_html, RedCloth.new(portfolio.body || '').to_html)
      end
    end

    NewsItem.transaction do
      NewsItem.find(:all).each do |news_item|
        news_item.update_attribute(:text_html, RedCloth.new(news_item.text || '').to_html)
      end
    end

    Site.transaction do
      Site.find(:all).each do |site|
        site.update_attribute(:home_text_html, RedCloth.new(site.home_text || '').to_html)
      end
    end
  end

  def self.down
    remove_column :portfolios, :body_html
    remove_column :news_items, :text_html
    remove_column :sites, :home_text_html
  end
end
