require_dependency 'article'

class Article
  before_validation :activity_gallery_save_into_author_folder
  after_validation :activity_gallery_change_visibility

  def activity_gallery_save_into_author_folder
    if not self.is_a? Folder and self.parent.kind_of? ActivityGalleryPlugin::ActivityGallery
      author_folder = self.parent.find_or_create_author_folder(self.author)
      self.name = ActivityGalleryPlugin::ActivityGallery.versioned_name(self, author_folder)
      self.parent = author_folder
    end
  end

  def activity_gallery_change_visibility
    if ActivityGalleryPlugin.is_submission?(self)
      related_activity_gallery = self.parent.parent

      if(!related_activity_gallery.publish_submissions)
        self.show_to_followers = false
      end

      self.published = self.parent.published
    end
  end
end