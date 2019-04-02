class LinkArticle < Article
  attr_accessible :reference_article

  def self.short_description
    "Article link"
  end

  def icon
    "link"
  end

  delegate :name, to: :reference_article
  delegate :body, to: :reference_article
  delegate :abstract, to: :reference_article
  delegate :url, to: :reference_article
  delegate :author, to: :reference_article
  delegate :created_by, to: :reference_article
end
