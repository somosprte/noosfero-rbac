class ActivityGalleryPlugin < Noosfero::Plugin

  def self.plugin_name
    "Activity Gallery"
  end

  def self.plugin_description
    _("RBAC activity gallery")
  end

  def self.can_download_submission?(user, submission)
      submission.published? || (user && (submission.author == user || user.has_permission?('view_private_content', submission.profile) ||
      submission.display_to?(user)))
  end

  def self.is_submission?(content)
    content && content.parent && content.parent.parent && content.parent.parent.kind_of?(ActivityGalleryPlugin::ActivityGallery)
  end

  def content_types
    [ActivityGalleryPlugin::ActivityGallery] if context.respond_to?(:profile)
  end

  def stylesheet?
    true
  end

  def content_remove_new(content)
    content.kind_of?(ActivityGalleryPlugin::ActivityGallery)
  end

  def content_remove_upload(content)
    if content.kind_of?(ActivityGalleryPlugin::ActivityGallery)
      !content.profile.members.include?(context.send(:user))
    end
  end

  def content_viewer_controller_filters
    block = proc do
      path = get_path(params[:page], params[:format])
      content = profile.articles.find_by path: path

      if ActivityGalleryPlugin.is_submission?(content) && !ActivityGalleryPlugin.can_download_submission?(user, content)
        render_access_denied
      end
    end

    { :type => 'before_action',
      :method_name => 'activity_gallery_only_admin_or_owner_download',
      :options => {:only => 'view_page'},
      :block => block }
  end

  def cms_controller_filters
    block = proc do
      if request.post? && params[:uploaded_files]
        email_notification = params[:article_email_notification]
        unless !email_notification || email_notification.empty?
          email_contact = ActivityGalleryPlugin::EmailContact.new(:subject => @parent.name, :receiver => email_notification, :sender => user)
          ActivityGalleryPlugin::EmailContact::EmailSender.build_mail_message(email_contact, @uploaded_files)
          if email_contact.deliver
            session[:notice] = _('Notification successfully sent')
          else
            session[:notice] = _('Notification not sent')
          end
        end
      end
    end

    { :type => 'after_action',
      :method_name => 'send_email_after_upload_file',
      :options => {:only => 'upload_files'},
      :block => block }
  end

  def upload_files_extra_fields(article)
    proc do
      @article = Article.find_by id: article
      if params[:parent_id] && !@article.nil? && @article.type == "ActivityGalleryPlugin::ActivityGallery"
        render :partial => 'notify_text_field',  :locals => { :size => '45'}
      end
    end
  end

   def self.load_custom_routes
    Noosfero::Application.routes.draw do
      get "/galeria", to: 'activity_gallery_plugin_activity#list', defaults: {profile: 'adminuser'}
      get "/sobre", to: 'activity_gallery_plugin_activity#about', defaults: {profile: 'adminuser'}
      get "/galeria/criativa-oficina-de-introducao-a-aprendizagem-criativa", to: 'activity_gallery_plugin_activity#item', defaults: {profile: 'adminuser'}
    end
  end
end
