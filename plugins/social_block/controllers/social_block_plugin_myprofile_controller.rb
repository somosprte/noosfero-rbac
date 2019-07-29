class SocialBlockPluginMyprofileController < MyProfileController
    def edit
        @block = profile.blocks.select { |b| b.type == 'SocialBlockPlugin::SocialBlock' }.first
    end

    def update
        @block = profile.blocks.select { |b| b.type == 'SocialBlockPlugin::SocialBlock' }.first
        @block.update(params[:block])
        redirect_to profile.url
    end
end