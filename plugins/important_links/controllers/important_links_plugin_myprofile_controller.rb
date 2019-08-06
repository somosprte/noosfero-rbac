class ImportantLinksPluginMyprofileController < MyProfileController
    def edit
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
        # @block.links << ImportantLinksPlugin::Link.new
    end

    def update
        @block = profile.blocks.select { |b| b.type == 'ImportantLinksPlugin::ImportantLinksBlock' }.first
        block_params[:links_attributes].each do |key, attrs|
            destroy = attrs.delete('_destroy')
            if attrs['id'].present?
                link = @block.links.find(attrs['id'])
                attrs.delete('id')
                if destroy == 'true'
                    link.destroy!
                else
                    link.update!(attrs)
                end
            else
                link = ImportantLinksPlugin::Link.new(attrs)
                link.block = @block
                link.save!
            end
        end
        #@block.update!(block_params)
        # @link = ImportantLinksPlugin::Link.last
        #raise block_params[:links_attributes]['0'].inspect
        # link_params = block_params[:links_attributes]['0']
        # link_params.delete('id')
        # link_params.delete('_destroy')
        # @link.update!(link_params)
        redirect_to profile.url
    end

    private

    def block_params
        params.require(:important_links_plugin_important_links_block).permit(links_attributes: [:id, :name, :address, :description, :_destroy, image_builder: [:uploaded_data]])
    end
end