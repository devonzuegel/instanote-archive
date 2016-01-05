class InstapaperClient
  LIMIT = 500  # Possible range is [0..500]

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

  def raw_bookmarks
    get_raw_bookmarks('archive')  # (get_bookmarks('archive') + get_bookmarks('starred')).uniq
  end

  def bookmarks
    get_bookmarks('archive')  # (get_bookmarks('archive') + get_bookmarks('starred')).uniq
  end

  def get_bookmarks(folder_id = 'unread')
    get_raw_bookmarks(folder_id).map { |b| build_bookmark(b) }
  end

  def get_raw_bookmarks(folder_id = 'unread')
    bookmarks = []
    results = @client.bookmarks(limit: LIMIT, folder_id: folder_id)[:bookmarks]
    results.each { |b| bookmarks << b }
    bookmarks
  end

  def get_text(bookmark)
    is_pdf = bookmark['url'].end_with?('.pdf')
    return bookmark['url'] if is_pdf
    begin
      text = @client.get_text(bookmark['bookmark_id'])
    rescue Instapaper::Error => e
      raise Instapaper::Error, "Failed to generate text version of this URL: #{bookmark['url']}"
    end
    text.force_encoding("utf-8")
  end

  def build_bookmark(bookmark)
    bookmark.deep_stringify_keys! if bookmark.class == Hash
    text        = get_text(bookmark)
    highlights  = @client.highlights(bookmark['bookmark_id'])
    {
      description:        bookmark['description'],
      bookmark_id:        bookmark['bookmark_id'],
      title:              bookmark['title'],
      url:                bookmark['url'],
      progress_timestamp: bookmark['progress_timestamp'],
      time:               bookmark['time'],
      progress:           bookmark['progress'].to_f,
      starred:            (bookmark['starred'] == '1') ? true : false,
      body:               build_highlighted_text(text, highlights),
      retrieved:          Time.now
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
