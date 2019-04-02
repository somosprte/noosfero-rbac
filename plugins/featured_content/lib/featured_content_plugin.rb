class FeaturedContentPlugin < Noosfero::Plugin

  def self.plugin_name
    "Featured Content Plugin"
  end

  def self.plugin_description
    _("Plugin that highlights only selected articles.")
  end

  def self.extra_blocks
    {
      FeaturedContentPlugin::FeaturedContentBlock => {:position => ['1','2','3'] }
    }
  end

  def self.has_admin_url?
    false
  end

  def stylesheet?
    true
  end

  def js_files
    ['js/featured_content.js']
  end

end
