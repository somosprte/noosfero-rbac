class SocialBlockPlugin::SocialBlock < Block

  metadata_items :facebook_link, :twitter_link, :linkedin_link, :instagram_link, :scratch_link

  def self.description
    _('Social Network Block')
  end

  def social_networks
    [:facebook, :twitter, :linkedin, :instagram, :scratch]
  end

end
