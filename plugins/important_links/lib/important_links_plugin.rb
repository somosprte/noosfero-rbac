class ImportantLinksPlugin < Noosfero::Plugin
  def self.plugin_name
    'Important Links'
  end

  def self.plugin_description
    _('Include a links with image and description.')
  end

  def self.extra_blocks
    {
      ImportantLinksBlock => {:type => [Person, Community, Enterprise], :position => ['1','2','3']}
    }
  end

  def stylesheet?
    true
  end

end
