require 'test_helper'

class ActivityGalleryTest < ActiveSupport::TestCase
  should 'find or create sub-folder based on author identifier' do
    profile = fast_create(Profile)
    author = fast_create(Person)
    activity_gallery = ActivityGalleryPlugin::ActivityGallery.create!(:name => 'Sample Work Assignment', :profile => profile)
    assert_nil activity_gallery.children.find_by slug: author.identifier

    folder = activity_gallery.find_or_create_author_folder(author)
    assert_not_nil activity_gallery.children.find_by slug: author.identifier
    assert_equal folder, activity_gallery.find_or_create_author_folder(author)
  end

  should 'return versioned name' do
    profile = fast_create(Profile)
    folder = fast_create(Folder, :profile_id => profile)
    a1 = Article.create!(:name => "Article 1", :profile => profile)
    a2 = Article.create!(:name => "Article 2", :profile => profile)
    a3 = Article.create!(:name => "Article 3", :profile => profile)
    klass = ActivityGalleryPlugin::ActivityGallery

    assert_equal "(V1) #{a1.name}", klass.versioned_name(a1, folder)

    a1.parent = folder
    a1.save!
    assert_equal "(V2) #{a2.name}", klass.versioned_name(a2, folder)

    a2.parent = folder
    a2.save!
    assert_equal "(V3) #{a3.name}", klass.versioned_name(a3, folder)
  end

  should 'move submission to its correct author folder' do
    organization = fast_create(Organization)
    author = fast_create(Person)
    activity_gallery = ActivityGalleryPlugin::ActivityGallery.create!(:name => 'Sample Work Assignment', :profile => organization)
    submission = create(UploadedFile, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'), :profile => organization, :parent => activity_gallery, :author => author)

    author_folder = activity_gallery.find_or_create_author_folder(author)
    assert_equal author_folder, submission.parent
  end

end
