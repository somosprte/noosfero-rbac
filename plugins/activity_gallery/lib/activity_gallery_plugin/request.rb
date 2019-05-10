class ActivityGalleryPlugin::Request
    class << self
        def request(method, url, body, jwt)
            base_url = "https://devapi.aprendizagemcriativa.org/"
            uri = URI.parse(base_url + url)
            request = method == :get ? Net::HTTP::Get.new(uri) : Net::HTTP::Post.new(uri)
            request.content_type = "application/json"
            request["Accept"] = "application/json"
            request["Authorization"] = "Bearer #{jwt}" if jwt.present?
            request.body = JSON.dump(body) if body.present?

            req_options = {
                use_ssl: uri.scheme == "https",
            }

            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end

            return response
        end

        def get(url, body=nil, jwt=nil)
            request(:get, url, body, jwt)
        end

        def post(url, body=nil, jwt=nil)
            request(:post, url, body, jwt)
        end

        def create_activity(activity)
            jwt = activity.author.metadata['activity_gallery_plugin_jwt']
            body = {
                "activity" => {
                    "title" => activity.metadata['title'],
                    "description" => activity.metadata['description'],
                    "caption" => activity.metadata['caption'],
                    "motivation" => activity.metadata['motivation'],
                    "powerful_ideas" => activity.metadata['powerful_ideas'],
                    "products" => activity.metadata['products'],
                    "requirements" => activity.metadata['requirements'],
                    "published" => activity.metadata['published'] == '1' ? true : false,
                    "version_history" => activity.metadata['version_history'],
                    "copyright" => activity.metadata['copyright'],
                    "license_type" => activity.metadata['license_type'],
                    "space_organization" => activity.metadata['space_organization'],
                    "implementation_steps" => activity.metadata['implementation_steps'],
                    "implementation_tips" => activity.metadata['implementation_tips'],
                    "inspiration" => activity.metadata['inspiration'],
                    "references" => activity.metadata['references'],
                    "reflection_assessment" => activity.metadata['reflection_assessment'],
                    "duration" => activity.metadata['duration'],
                    "scope_ids" => activity.metadata['scopes'],
                    "audience_ids" => activity.metadata['audience'],
                    "space_type_ids" => activity.metadata['space_types'],
                    "person_ids" => activity.metadata['authors'].split(','),
                    # "audience_ids" => [activity.metadata['audience']],
                    "general_materials" => [
                        {
                            "id" => "9c65a353-497a-42ed-9631-38f68c6862b0",
                            "quantity" => 11
                        }
                    ]
                }
            }
            body['activity']['image'] = "data:image/png;base64," + Base64.encode64(activity.image.current_data) if activity.image.present?
            resultado = ActivityGalleryPlugin::Request.post("gallery/v1/activities", body, jwt)
        end
    end
end