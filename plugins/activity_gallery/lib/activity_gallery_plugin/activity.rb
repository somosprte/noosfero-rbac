class ActivityGalleryPlugin::Activity

  attr_accessor :id, :type, :title, :description, :caption, :motivation, :powerful_ideas, :products, :requirements, :published, :version_history, :copyright, :license_type, :space_organization, :implementation_steps, :implementation_tips, :inspirations, :references, :reflection_assessment, :remixed, :liked, :favorited, :implemented, :duration, :scopes, :audiences, :space_types, :authors, :specific_materials, :general_materials, :image, :images, :image_builder, :comments, :likes, :implementations, :total_implementations, :total_likes, :total_comments, :total_favorites, :total_remixes, :remixes, :created_at, :updated_at, :is_abac_author, :inserted_by, :external_authors, :external_link, :activity_type, :license
  attr_accessor :language

  def initialize(data={attributes: {license: {}}})
    @id = data[:id]
    @type = data[:type]
    data[:attributes].each { |key, value| send "#{key.to_s.underscore}=", value } if data[:attributes].present?
    @image ||=  "data:image/png;base64," + Base64.encode64(image_builder["uploaded_data"].read) if image_builder.present? && image_builder["uploaded_data"].present?
  end

  def name
    title
  end

  def ensure_author(id)
    if authors.blank? || !authors.split(',').any? { |i| i == id }
      self.authors ||= ''
      self.authors = (authors.split(',') << id).join(',')
    end
  end

  def tokenized_authors
    authors.map { |author| {:id => author[:id], :name => author[:name]} } if authors.present?
  end

  def tokenized_inspirations
    inspirations.map { |inspiration| {:id => inspiration[:activity_two_id], :name => inspiration[:title]} } if inspirations.present?
  end

  def check(object_type, object_id)
    send(object_type).any? { |object| object[:id] == object_id } if send(object_type).present?
  end

  def is_author?(person)
    metadata = Noosfero::Plugin::Metadata.new(person, ActivityGalleryPlugin)
    authors.present? && authors.any? { |author| author[:id] == metadata.person_id }
  end

  def original_image
    if images.present? && images[:original].present?
      uploaded_data = Rack::Test::UploadedFile.new(open(images[:original]).path, 'image/jpeg')
      Image.create!(uploaded_data: uploaded_data)
    end
  end

  def body
    result = {"activity" => {
      "title" => title,
      "activity_type" => activity_type,
      "description" => description,
      "caption" => caption,
      "motivation" => motivation,
      "powerful_ideas" => powerful_ideas,
      "products" => products,
      "requirements" => requirements,
      "published" => published == '1' ? true : false,
      "is_abac_author" => is_abac_author,
      "version_history" => version_history,
      "copyright" => copyright,
      "license_type" => license_type,
      "external_link" => external_link,
      "space_organization" => space_organization,
      "implementation_steps" => implementation_steps,
      "implementation_tips" => implementation_tips,
      "inspirations_ids" => inspirations.try(:split, ',') || [],
      "references" => references,
      "reflection_assessment" => reflection_assessment,
      "duration" => duration,
      "scope_ids" => scopes || [],
      "audience_ids" => audiences|| [],
      "space_type_ids" => space_types|| [],
      "license_id" => license.to_h[":id"],
      "person_ids" => authors.try(:split, ','),
      "external_authors" => external_authors.try(:split, ','),
      "specific_materials" => specific_materials || [],
      "general_materials" => general_materials.try(:map, &:to_h) || []
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

  def self.get_license_options(jwt)
    url = "gallery/v1/licenses/?per=50"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @license = JSON.parse(result.body,symbolize_names:true)
    result = []
    @license[:data].each do |license|
      field = [license[:attributes][:title], license[:id]]
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
    url = "gallery/v1/general_materials/?per=50"
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
    url = "user/v1/people/?per=200"
    result = ActivityGalleryPlugin::Request.get(url, nil, jwt)
    @authors = JSON.parse(result.body,symbolize_names:true)
    result = []
    @authors[:data].each do |authors|
      field = [authors[:attributes][:name], authors[:id]]
      result.push(field)
    end
    result
  end

  def self.get_activity_type_options
    [
      ['Todos os tipos',''],
      ['Atividade Interna','internal'],
      ['Atividade Externa','external']
    ]
  end

  def self.get_order_options
    [
      ['Ordenação Padrão',''],
      ['Título (A -> Z)','title%20ASC'],
      ['Título (Z -> A)','title%20DESC'],
      ['Data de atualização','updated_at%20DESC'],
      ['Mais Favoritadas','total_favorites%20DESC'],
      ['Mais implementadas','total_implementations%20DESC'],
      ['Mais remixadas','total_remixes%20DESC'],
    ]
  end

end
