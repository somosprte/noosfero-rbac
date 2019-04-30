class ActivityGalleryPlugin::Request
    class << self
        def request(method, url, session, body)
            base_url = "https://devapi.aprendizagemcriativa.org/"
            uri = URI.parse(base_url + url)
            request = method == :get ? Net::HTTP::Get.new(uri) : Net::HTTP::Post.new(uri)
            request.content_type = "application/json"
            request["Accept"] = "application/json"
            request["Authorization"] = "Bearer #{session['activity_gallery_plugin_jwt']}"
            request.body = JSON.dump(body) if body.present?

            req_options = {
                use_ssl: uri.scheme == "https",
            }

            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end

            return response
        end

        def get(url, session=nil, body=nil) 
            request(:get, url, session, body)
        end

        def post(url, session=nil, body=nil) 
            request(:post, url, session, body)
        end

        def create_activity(activity)
            body = {
                "activity" => {
                    "title" => activity.metadata['title'],
                    "description" => activity.metadata['description'],
                    "caption" => activity.metadata['caption'],
                    "motivation" => activity.metadata['motivation'],
                    "powerful_ideas" => activity.metadata['powerful_ideas'],
                    "audience_ids" => [activity.metadata['audience']],
                    "general_materials" => [
                        {
                            "id" => "9c65a353-497a-42ed-9631-38f68c6862b0",
                            "quantity" => 11
                        }
                    ]
                }
            }
            ActivityGalleryPlugin::Request.post("gallery/v1/activities", body)
        end
    end
end