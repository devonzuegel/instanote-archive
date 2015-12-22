class InstapaperClient
  LIMIT = 2  # Possible range is [0..500]

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
    get_bookmarks('archive')  # (get_bookmarks('archive') + get_bookmarks('starred')).uniq
  end

  def get_bookmarks(folder_id = 'unread')
    bookmarks = []
    @client.bookmarks(limit: LIMIT, folder_id: folder_id).each do |b|
     bookmarks << build_bookmark(b)
   end
    bookmarks
  end

  def build_bookmark(bookmark)
    bookmark.deep_stringify_keys! if bookmark.class == Hash
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
      progress:           bookmark['progress'].to_f,
      starred:            (bookmark['starred'] == '1') ? true : false,
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
