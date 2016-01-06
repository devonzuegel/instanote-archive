# TODO refactor me!
# TODO add many tests

class EvernoteClient
  include EvernoteParsable

  OFFSET    = 0
  N_RESULTS = 100
  ORIGIN_STAMP = "\n\n\n" + "<i>via <a href='https://instanote-archive.herokuapp.com/'>Instanote</a></i>"

  def initialize(attributes = {})
    @auth_token = attributes.fetch(:auth_token)
    @client = EvernoteOAuth::Client.new(token: @auth_token, sandbox: !Rails.env.production?)
    ping_evernote
  end

  def store_note_from_bookmark!(bookmark)
    note = note_from_bookmark(bookmark)
    store_note!(note)
  end

  def store_note!(our_note)
    begin  # Attempt to create note in Evernote account
      note = note_store.createNote(our_note)
    rescue Evernote::EDAM::Error::EDAMUserException => edue
      puts " EDAMUserException:                 \n" +
           " > errorCode: #{edue.errorCode}     \n" +
           " > parameter: #{edue.parameter}       "
      return nil
    rescue Evernote::EDAM::Error::EDAMNotFoundException => ednfe
      puts "EDAMNotFoundException: Invalid parent notebook GUID"
      return nil
    end

    note
  end

  def note_from_bookmark(bookmark)
    notebook  = nil  # PLACEHOLDER
    attrs     = Evernote::EDAM::Type::NoteAttributes.new(
      sourceURL:         bookmark.url,
      sourceApplication: 'Instapaper',
      author:   bookmark.user.name,
    )
    note_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                          +
                "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">" +
                "<en-note>#{html_to_enml(bookmark[:body])}#{ORIGIN_STAMP}</en-note>"

    # Create note object. `notebook` is optional; if omitted, default notebook is used.
    note = Evernote::EDAM::Type::Note.new(
      title:      bookmark[:title],
      content:    note_body,
      tagNames:   [],
      attributes: attrs
    )
    note.notebookGuid = notebook.guid if notebook && notebook.guid

    note
  end

  def notebooks
    note_store.listNotebooks(@auth_token).map { |n| format_notebook(n) }
  end

  def notebook_counts
    note_store.findNoteCounts(@auth_token, filter, false)
  end

  def en_user
    user_store.getUser(@auth_token)
  end

  def notes_metadata
    note_store.findNotesMetadata(filter, OFFSET, N_RESULTS, notes_metadata_result_spec)
  end

  def notes
    note_guids = notes_metadata.notes.map(&:guid)
    notes      = note_guids.map { |guid| find_note_by_guid(guid) }
  end

  def find_note_by_guid(guid)
    note = note_store.getNote(@auth_token, guid, true, true, true, true)
    format_note(note)
  end

  private

  def user_store
    @client.user_store
  end

  def note_store
    @client.note_store
  end

  def ping_evernote
    note_store
  rescue Evernote::EDAM::Error::EDAMUserException => e
    raise Evernote::EDAM::Error::EDAMUserException, 'Invalid authentication token.'
  end

  def filter
    Evernote::EDAM::NoteStore::NoteFilter.new
  end

  def notes_metadata_result_spec
    Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new(
      includeTitle:         true,
      includeContentLength: true,
      includeCreated:       true,
      includeUpdated:       true,
      includeDeleted:       true,
    )
  end
end
