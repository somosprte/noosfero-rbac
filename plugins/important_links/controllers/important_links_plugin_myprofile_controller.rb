class ImportantLinksPluginMyprofileController < MyProfileController
    def edit
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
    end

    def update
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
        @block.update(params[:block])
        redirect_to profile.url
    end
end