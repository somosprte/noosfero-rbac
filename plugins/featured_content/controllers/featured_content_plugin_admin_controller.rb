class FeaturedContentPluginAdminController < PluginAdminController

    def search_articles
        arg = params[:q].downcase
        result = environment.portal_community.articles.where('LOWER(name) LIKE ? and type = ?', "%#{arg}%", "TextArticle")
        render plain: prepare_to_token_input(result).to_json
    end

end 

