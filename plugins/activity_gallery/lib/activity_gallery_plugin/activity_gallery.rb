class ActivityGalleryPlugin::ActivityGallery < Folder

  settings_items :default_email, :type => :string, :default => ""

  attr_accessible :default_email

  after_create do |activity|
    response = ActivityGalleryPlugin::Request.create_activity(activity)
    activity.destroy if response.code=='200'
  end

  def self.icon_name(article = nil)
    'activity'
  end

  def self.get_audience_options(session)
    url = "gallery/v1/audiences"
    result = ActivityGalleryPlugin::Request.get(url, session)
    @audiences = JSON.parse(result.body,symbolize_names:true)
    result = []
    @audiences[:data].each do |audience|
      field = [audience[:attributes][:name], audience[:id]]
      result.push(field)
    end
    result
  end

  def self.short_description
    _('Activity Gallery')
  end

  def self.description
    _('Defines a work to be done by the members and receives their submissions about this work.')
  end

  # def accept_comments?
  #   true
  # end

  def allow_create?(user)
    profile.members.include?(user)
  end

  def to_html(options = {})
    -> context { render :file => 'content_viewer/activity_gallery.html.erb' }
  end

  def accept_uploads?
    false
  end
end
