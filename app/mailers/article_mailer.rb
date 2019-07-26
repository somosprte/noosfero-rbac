class ArticleMailer < ApplicationMailer
  
    def new_content_for_followers(content, emails)
      profile = content.profile
      self.environment = profile.environment
  
      @recipient = profile.nickname || profile.name
      @sender = content.author_name
      @sender_link = content.author_url
      @content_title = content.title
      @parent_title = content.parent.title
      @content_url = content.url
      @url = profile.environment.top_url
  
      mail(
        bcc: emails,
        from: "#{profile.environment.name} <#{profile.environment.noreply_email}>",
        subject: _("[%s] %s create a new content on %s") % [profile.environment.name, content.author_name, @parent_title]
      )
    end
  end
  