module EvernoteParsable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  module InstanceMethods
    private
    BLACKLISTED_TAGS = %w(figure)

    def html_to_enml(text)
      doc  = Nokogiri::HTML( text.force_encoding("utf-8") )
      BLACKLISTED_TAGS.each { |t| doc.search(t).remove }
      sanitized = Sanitize.fragment(
        doc.to_html,
        elements:   %w(h1 h2 h3 h4 h5 h6 strong i p b a span ul ol li),
        attributes: { 'a' => %w(href), 'span' => %w(style) },
        protocols:  { 'a' => { 'href' => %w(ftp http https mailto) } }
      )
      highlight_style_spans(sanitized)
    end

    def highlight_style_spans(html)
      old_fragment = '<span>'
      new_fragment = '<span style="-evernote-highlighted:true; background-color:#FFFFb0">'
      html.gsub!(old_fragment, new_fragment)
    end

    def format_note(note)
      {
        guid:          note.guid,
        title:         note.title,
        content:       note.content,
        en_created_at: timestamp_to_datetime(note.created),
        en_updated_at: timestamp_to_datetime(note.updated),
        active:        note.active,
        notebook_guid: note.notebookGuid,
        author:        note.attributes.author
      }
    end

    def format_notebook(notebook)
      {
        en_created_at: timestamp_to_datetime(notebook.serviceCreated),
        en_updated_at: timestamp_to_datetime(notebook.serviceUpdated),
        guid: notebook.guid,
        name: notebook.name,
        user_id: @user_id
      }
    end

    def timestamp_to_datetime(timestamp)
      epoch = timestamp.to_s.chomp('000')
      DateTime.strptime(epoch, '%s')
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end