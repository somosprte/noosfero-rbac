class ActivityGalleryPlugin::Activity

  attr_accessor :id, :type, :title, :description, :caption, :motivation, :powerful_ideas, :products, :requirements, :published, :version_history, :copyright, :license_type, :space_organization, :implementation_steps, :implementation_tips, :inspirations, :references, :reflection_assessment, :remixed, :liked, :favorited, :implemented, :duration, :scopes, :audiences, :space_types, :authors, :specific_materials, :general_materials, :image, :images, :image_builder
  attr_accessor :language

  def initialize(data={})
    @id = data[:id]
    @type = data[:type]
    data[:attributes].each { |key, value| send "#{key.to_s.underscore}=", value } if data[:attributes].present?
    @image ||=  "data:image/png;base64," + Base64.encode64(image_builder["uploaded_data"].read) if image_builder.present?
  end

  def tokenized_authors
    authors.map { |author| {:id => author[:id], :name => author[:name]} } if authors.present?
  end

  def tokenized_inspirations
    inspirations.map { |inspiration| {:id => inspiration[:id], :name => inspiration[:name]} } if inspirations.present?
  end

  def check(object_type, object_id)
    send(object_type).any? { |object| object[:id] == object_id } if send(object_type).present?
  end

  def is_author?(person)
    authors.present? && authors.any? { |author| author[:email] == person.email }
  end

  def body
    result = {"activity" => {
      "title" => title,
      "description" => description,
      "caption" => caption,
      "motivation" => motivation,
      "powerful_ideas" => powerful_ideas,
      "products" => products,
      "requirements" => requirements,
      "published" => published == '1' ? true : false,
      "version_history" => version_history,
      "copyright" => copyright,
      "license_type" => license_type,
      "space_organization" => space_organization,
      "implementation_steps" => implementation_steps,
      "implementation_tips" => implementation_tips,
      "inspirations_ids" => inspirations.try(:split, ','),
      "references" => references,
      "reflection_assessment" => reflection_assessment,
      "duration" => duration,
      "scope_ids" => scopes,
      "audience_ids" => audiences,
      "space_type_ids" => space_types,
      "person_ids" => authors.try(:split, ','),
      "specific_materials" => specific_materials,
      "general_materials" => [
        {
        "id": "9c65a353-497a-42ed-9631-38f68c6862b0",
        "quantity": 11
      }
      ]
    }}
    result['activity']['image'] = image if image.present?
    result
  end

  def self.get_audience_options(jwt)
    url = "gallery/v1/audiences/?per=50"
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
    url = "gallery/v1/scopes/?per=50"
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
    url = "gallery/v1/space_types/?per=50"
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

end
