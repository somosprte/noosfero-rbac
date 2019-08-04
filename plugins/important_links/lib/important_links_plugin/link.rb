class ImportantLinksPlugin::Link < ApplicationRecord

    attr_accessible :name, :address, :description

    belongs_to :block, class_name: 'ImportantLinksPlugin::ImportantLinksBlock'

    extend ActsAsHavingImage::ClassMethods
    acts_as_having_image

end
  