require 'test_helper'

class CmsControllerTest < ActionController::TestCase

  def setup
    @controller = CmsController.new

    @person = create_user('test_user').person
    login_as :test_user
    e = Environment.default
    e.enabled_plugins = ['ActivityGalleryPlugin']
    e.save!
    @organization = fast_create(Organization) #
  end

  should 'not allow non-members to upload submissions on activity_gallery' do
    activity_gallery = create_activity_gallery('Work Assignment', @organization, nil, nil)
    get :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id
    assert_response :forbidden
    assert_template 'shared/access_denied'
  end

  should 'allow members to upload submissions on activity_gallery' do
    @organization.add_member(@person)
    # then he trys to upload new stuff
    activity_gallery = create_activity_gallery('Work Assignment', @organization, nil, nil)
    get :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id
    assert_response :success
  end

  should 'redirect to Work Assignment view page after upload submission' do
    @organization.add_member(@person)
    activity_gallery = create_activity_gallery('Work Assignment', @organization, nil, nil)
    post :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain')}},
         :back_to => @activity_gallery.url
    assert_redirected_to activity_gallery.url
  end

  should 'upload submission and automatically move it to the author folder' do
    activity_gallery = create_activity_gallery('Work Assignment', @organization, nil, nil)
    @organization.add_member(@person)
    post :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain')}}
    submission = UploadedFile.last
    assert_equal activity_gallery.find_or_create_author_folder(@person), submission.parent
  end

  should 'activity_gallery attribute allow_visibility_edition is true when set a new activity_gallery' do
    activity_gallery = create_activity_gallery('Work Assignment', @organization, nil, true)
    @organization.add_member(@person)
    assert_equal true, activity_gallery.allow_visibility_edition
  end

  should 'a submission and parent attribute "published" be equal to Work Assignment attribute publish submissions' do
    @organization.add_member(@person)
    activity_gallery = create_activity_gallery('Work Assignment', @organization, true, nil)
    assert_equal true, activity_gallery.publish_submissions
    post :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain')}}
    submission = UploadedFile.last
    assert_equal activity_gallery.publish_submissions, submission.published
    assert_equal activity_gallery.publish_submissions, submission.parent.published

    other_activity_gallery = create_activity_gallery('Other Work Assigment', @organization, false, nil)
    assert_equal false, other_activity_gallery.publish_submissions
    post :upload_files, :profile => @organization.identifier, :parent_id => other_activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain')}}
    submission = UploadedFile.last
    assert_equal other_activity_gallery.publish_submissions, submission.published
    assert_equal other_activity_gallery.publish_submissions, submission.parent.published
  end

  should 'submission inherit Work Assignment "published" attribute and not be set as show_to_followers when it is not public' do
    @organization.add_member(@person)
    activity_gallery = create_activity_gallery('Work Assignment', @organization, false, nil)

    assert !activity_gallery.publish_submissions

    post :upload_files, :profile => @organization.identifier, :parent_id => activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain') }}
    submission = UploadedFile.last

    assert !submission.show_to_followers?
    assert_equal activity_gallery.publish_submissions, submission.published
    assert_equal activity_gallery.publish_submissions, submission.parent.published

    other_activity_gallery = create_activity_gallery('Other Work Assigment', @organization, true, nil)

    assert_equal true, other_activity_gallery.publish_submissions

    post :upload_files, :profile => @organization.identifier, :parent_id => other_activity_gallery.id,
         :uploaded_files => { "0" => { :file => fixture_file_upload('/files/test.txt', 'text/plain')}}
    submission = UploadedFile.last

    assert submission.show_to_followers?
    assert_equal other_activity_gallery.publish_submissions, submission.published
    assert_equal other_activity_gallery.publish_submissions, submission.parent.published
  end

  private
    def create_activity_gallery(name = nil, profile = nil, publish_submissions = nil, allow_visibility_edition = nil)
      @activity_gallery = ActivityGalleryPlugin::ActivityGallery.create!(:name => name, :profile => profile, :publish_submissions => publish_submissions, :allow_visibility_edition => allow_visibility_edition)
    end
end
