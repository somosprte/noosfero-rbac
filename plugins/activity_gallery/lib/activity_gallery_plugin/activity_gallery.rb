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

  def self.get_audience_options(jwt)
    url = "gallery/v1/audiences"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @audiences = JSON.parse(result.body,symbolize_names:true)
    result = []
    @audiences[:data].each do |audience|
      field = [audience[:attributes][:name], audience[:id]]
      result.push(field)
    end
    result
  end

  def self.get_scopes_options(jwt)
    url = "gallery/v1/scopes"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @scopes = JSON.parse(result.body,symbolize_names:true)
    result = []
    @scopes[:data].each do |scopes|
      field = [scopes[:attributes][:title], scopes[:id]]
      result.push(field)
    end
    result
  end

  def self.get_space_types_options(jwt)
    url = "gallery/v1/space_types"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @space_types = JSON.parse(result.body,symbolize_names:true)
    result = []
    @space_types[:data].each do |space_types|
      field = [space_types[:attributes][:title], space_types[:id]]
      result.push(field)
    end
    result
  end

  def self.get_general_materials_options(jwt)
    url = "gallery/v1/general_materials"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @general_materials = JSON.parse(result.body,symbolize_names:true)
    result = []
    @general_materials[:data].each do |general_materials|
      field = [general_materials[:attributes][:name], general_materials[:id]]
      result.push(field)
    end
    result
  end

  def self.get_specific_materials_options(jwt)
    url = "gallery/v1/specific_materials"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @specific_materials = JSON.parse(result.body,symbolize_names:true)
    result = []
    @specific_materials[:data].each do |general_materials|
      field = [specific_materials[:attributes][:name], specific_materials[:id]]
      result.push(field)
    end
    result
  end

  def self.get_authors_options(jwt)
    url = "user/v1/people"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @authors = JSON.parse(result.body,symbolize_names:true)
    result = []
    @authors[:data].each do |authors|
      field = [authors[:attributes][:name], authors[:id]]
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
