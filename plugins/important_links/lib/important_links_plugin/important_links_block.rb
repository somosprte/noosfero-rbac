class ImportantLinksPlugin::ImportantLinksBlock < Block

  metadata_items :image, :name, :description, :link

  def self.description
    _('Important Links Block')
  end

end
