class InstapaperClient
  LIMIT = 2  # Max allowed is 500

  def initialize(instapaper_account)
    @credentials = {
      consumer_key:       ENV['instapaper_consumer_key'],
      consumer_secret:    ENV['instapaper_consumer_secret'],
      oauth_token:        instapaper_account.token,
      oauth_token_secret: instapaper_account.secret
    }
    @client = Instapaper::Client.new(@credentials)
    @client.verify_credentials
  end

  def bookmarks
    archived #(archived + starred).uniq
  end

  def archived
    archived = []
    @client.bookmarks(limit: LIMIT, folder_id: 'archive').each { |b| archived << build_bookmark(b) }
    archived
  end

  def starred
    starred = []
    @client.bookmarks(limit: LIMIT, folder_id: 'starred').each { |b|  starred << build_bookmark(b) }
    starred
  end

  def build_bookmark(bookmark)
    bookmark_id = bookmark['bookmark_id']
    text        = @client.get_text(bookmark_id).force_encoding("utf-8")
    highlights  = @client.highlights(bookmark_id)
    {
      description:        bookmark['description'],
      bookmark_id:        bookmark_id,
      title:              bookmark['title'],
      url:                bookmark['url'],
      progress_timestamp: bookmark['progress_timestamp'],
      time:               bookmark['time'],
      progress:           bookmark['progress'],
      starred:            bookmark['starred'],
      type:               bookmark['type'],
      body:               build_highlighted_text(text, highlights)
    }
  end

  def build_highlighted_text(text, highlights)
    open_tag  = '<span class="highlighted">'
    close_tag = '</span>'
    highlights.each do |h|
      highlighted_str = "#{open_tag}#{h[:text]}#{close_tag}"
      text.gsub!(h[:text], highlighted_str)
    end
    text
  end

  def sanitize(text)
    html = text.force_encoding("utf-8")
    doc  = Nokogiri::HTML(html)
    doc.search('figure').remove

    sanitized = Sanitize.fragment(
      doc.to_html,
      elements:   %w(h1 h2 h3 h4 h5 h6 strong i p b a span ul ol li),
      attributes: {
        'a'    => %w(href),
        'span' => %w(style)
      },
      protocols:  {
        'a'   => {'href' => %w(ftp http https mailto)}
      }
    )
    sanitized
  end
end
