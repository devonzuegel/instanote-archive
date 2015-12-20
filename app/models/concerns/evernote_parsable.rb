module EvernoteParsable
  extend ActiveSupport::Concern

  module ClassMethods
    EDAM_NOTE_CONTENT_LEN_MAX = 5_242_880  # dev.evernote.com/doc/reference/Limits.html#Const_EDAM_NOTE_CONTENT_LEN_MAX
  end

  module InstanceMethods

    def wrap_highlights(text, highlights)
      # open_tag  = '<span style="-evernote-highlighted:true; background-color:#f6ee96">'
      # close_tag = '<\span>'
      raise Exception
    end

    private

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