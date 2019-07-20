require 'net/http'
require 'uri'
require 'json'

class RbacPlugin < Noosfero::Plugin
  include Noosfero::Plugin::HotSpot

  config_path = Rails.root.join('plugins', 'rbac', 'config.yml')
  RBAC_CONFIG = File.exists?(config_path) ? YAML.load_file(config_path) : {}
  LOG_DIR_PATH = Rails.root.join('plugins', 'rbac', 'log')
  LOG_PATH = Rails.root.join('plugins', 'rbac', 'log', 'get_response.log')
  
  
  def self.plugin_name
    "Rbac"
  end

  def self.plugin_description
    "Plugin para funcões específicas do Rbac"
  end

  def person_after_create_callback(person)
    uri = URI.parse("https://api.getresponse.com/v3/contacts")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Postman-Token"] = RBAC_CONFIG['postman_token']
    request["X-Auth-Token"] = RBAC_CONFIG['auth_token']
    request["Cache-Control"] = "no-cache"
    request.body = JSON.dump({
      "name" => person.name,
      "email" => person.email,
      "campaign" => {
        "campaignId" => RBAC_CONFIG['campaign_id']
      }
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    if response.body['httpStatus'] != 202
      unless File.directory?(LOG_DIR_PATH)
        FileUtils.mkdir(LOG_DIR_PATH)
      end
      log = File.open(LOG_PATH, 'a+')
      log.write("\n===== [#{Time.now}] =====\n\n")
      log.write(response.body)
      log.write("\n\n===== =====\n")
      log.close
    end
  end

  def content_remove_new(content)
    content.blog? || (content.parent.present? && content.parent.blog?)
  end

  def article_extra_toolbar_buttons(content)
    parent = content.blog? ? content : (content.parent.present? && content.parent.blog?) ? content.parent : nil
    if parent.present?
      { :title => _('New post'), :icon => :file, :url => {controller: 'cms', action: 'new', parent: parent, type: 'TextArticle', profile: profile.identifier} }
    end
  end

end
