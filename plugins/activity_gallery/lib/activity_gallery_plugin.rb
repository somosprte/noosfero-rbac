class ActivityGalleryPlugin < Noosfero::Plugin

  def self.plugin_name
    "Activity Gallery"
  end

  def self.plugin_description
    _("RBAC activity gallery")
  end

  def content_types
    [ActivityGalleryPlugin::ActivityGallery] if context.respond_to?(:profile)
  end

  def stylesheet?
    true
  end

  # def person_after_create_callback(person)

  # end

  def account_controller_filters
    {
      type: 'after_action', method_name: 'get_jwt',
      options: { only: :login },
      block: proc {
        if logged_in?
          body = {
            "auth" => {
              "username" => "nivaldo@prte.com.br",
              "password" => "123456"
            }
          }
          response = ActivityGalleryPlugin::Request.post('auth/v1/users/login', body)
          if response.code == '200'
            jwt = JSON.parse(response.body,symbolize_names:true)[:jwt]
            session['activity_gallery_plugin_jwt'] = jwt
            user.metadata['activity_gallery_plugin_jwt'] = jwt
            user.save!
          else
          end
        end
      }
    }
  end

  def self.load_custom_routes
    Noosfero::Application.routes.draw do
      get "/galeria", to: 'activity_gallery_plugin_activity#list', defaults: {profile: 'portal'}
      get "/sobre", to: 'activity_gallery_plugin_activity#about', defaults: {profile: 'portal'}
      get "/galeria/item", to: 'activity_gallery_plugin_activity#item', defaults: {profile: 'portal'}
    end
  end
end
