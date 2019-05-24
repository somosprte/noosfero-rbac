class ActivityGalleryPlugin::Request
    class << self
        def request(method, url, body, jwt)
            base_url = "https://devapi.aprendizagemcriativa.org/"
            uri = URI.parse(base_url + url)
            request = "Net::HTTP::#{method.to_s.camelize}".constantize.new(uri)
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

        def delete(url, body=nil, jwt=nil)
            request(:delete, url, body, jwt)
        end

        def put(url, body=nil, jwt=nil)
            request(:put, url, body, jwt)
        end
    end
end