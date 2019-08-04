class ImportantLinksPlugin::ImportantLinksBlock < Block
  attr_accessible :links_attributes
  has_many :links, class_name: 'ImportantLinksPlugin::Link', foreign_key: 'block_id'
  accepts_nested_attributes_for :links,
    :allow_destroy => true,
    :reject_if     => :all_blank

  def self.description
    _('Important Links Block')
  end

end
