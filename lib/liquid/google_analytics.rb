class GoogleAnalytics < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    super
  end
  
  def rlogger() RAILS_DEFAULT_LOGGER end
  
  def render(context)
    site = context['site']
    return '' if site.nil? || site['google_analytics_code'].blank?
    <<-END
      <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
        var pageTracker = _gat._getTracker("#{site['google_analytics_code']}");
        pageTracker._initData();
        pageTracker._trackPageview();
      </script>
    END
  end
end

Liquid::Template.register_tag('googleanalytics', GoogleAnalytics)
