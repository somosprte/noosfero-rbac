class ActivityGalleryPlugin < Noosfero::Plugin

  def self.plugin_name
    "Activity Gallery"
  end

  def self.plugin_description
    _("RBAC Activity Gallery")
  end

  def self.extra_blocks
    {
      ActivityGalleryPlugin::ActivityGalleryBlock => {:type => 'person', :position => ['1','2','3'] }
    }
  end

  def stylesheet?
    true
  end

  def person_after_create_callback(person)
    body = {"auth" => {
      "email" => person.user.email,
      "password" => person.user.crypted_password,
      "name" => person.name,
      "birthday" => person.birth_date
    }}
    ActivityGalleryPlugin::Request.post("/auth/v1/users/register", body)
  end

  def account_controller_filters
    {
      type: 'after_action', method_name: 'get_jwt',
      options: { only: :login },
      block: proc {
        if logged_in?
          body = {
            "auth" => {
              "username" => user.email,
              "password" => user.user.crypted_password
            }
          }
          response = ActivityGalleryPlugin::Request.post('auth/v1/users/login', body)
          if response.code == '200'
            data = JSON.parse(response.body,symbolize_names:true)
          elsif response.code == '400'
            ActivityGalleryPlugin.new.person_after_create_callback(user)
            response = ActivityGalleryPlugin::Request.post('auth/v1/users/login', body)
            data = JSON.parse(response.body,symbolize_names:true)
          end
          session['activity_gallery_plugin_jwt'] = data[:jwt]
          # session['activity_gallery_plugin_user_id'] = data[:id]

          response = ActivityGalleryPlugin::Request.get('/user/v1/people/', nil, session['activity_gallery_plugin_jwt'])
          data = JSON.parse(response.body,symbolize_names:true)[:data]
          id = data.select { |u| u[:attributes][:email] == user.email }.first[:id]
          session['activity_gallery_plugin_user_id'] = id
        end
      }
    }
  end

  def self.load_custom_routes
    Noosfero::Application.routes.draw do
      get "/galeria", to: 'activity_gallery_plugin_activity#index'
      get "/galeria/atividades-curtidas", to: 'activity_gallery_plugin_activity#saved_activities'
      get "/galeria/atividades-implementadas", to: 'activity_gallery_plugin_activity#implemented_activities'
      get "/galeria/minhas-atividades", to: 'activity_gallery_plugin_activity#my_activities'
      get "/galeria/nova-atividade", to: 'activity_gallery_plugin_activity#new'
      get "/galeria/editar-atividade/:id", to: 'activity_gallery_plugin_activity#edit'
      get "/galeria/remixar-atividade/:id", to: 'activity_gallery_plugin_activity#remix'
      get "/sobre", to: 'activity_gallery_plugin_activity#about'
      get "/biblioteca", to: 'activity_gallery_plugin_activity#library'
      get "/galeria/:id", to: 'activity_gallery_plugin_activity#show'
    end
  end
end
