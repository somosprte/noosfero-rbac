class ImportantLinksPluginMyprofileController < MyProfileController
    def edit
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
        @block.links << ImportantLinksPlugin::Link.new
    end

    def update
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
        @block.update(block_params)
        redirect_to profile.url
    end

    private

    def block_params
        params.require(:important_links_plugin_important_links_block).permit(links_attributes: [:id, :name, :address, :description])
    end
end