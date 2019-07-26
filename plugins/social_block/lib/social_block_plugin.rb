class SocialBlockPlugin < Noosfero::Plugin
  def self.plugin_name
    'Social Block'
  end

  def self.plugin_description
    _('Includes a social newtork icons and links.')
  end

  def self.extra_blocks
    {
      SocialBlock => {:type => [Person, Enterprise], :position => ['1','2','3']}
    }
  end

  def stylesheet?
    true
  end

end
