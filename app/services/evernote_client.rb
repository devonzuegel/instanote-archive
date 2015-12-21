# TODO refactor me!
# TODO add many tests

class EvernoteClient
  include EvernoteParsable

  OFFSET    = 0
  N_RESULTS = 100

  def initialize(attributes = {})
    @auth_token = attributes.fetch(:auth_token)
    @client = EvernoteOAuth::Client.new(token: @auth_token)
    ping_evernote
  end

  def note_from_bookmark(bookmark)
    parent_notebook = nil
    note_title = bookmark[:title]
    note_body  = html_to_enml(bookmark[:text])#.slice(bookmark[:text].index('<html>')..-1)
    # # CGI.unescapeHTML()
    # puts 'NOTE BODY: --------------------------------------------------'
    # puts note_body
    # puts '-------------------------------------------------------------'

    n_body  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
    n_body += "<en-note>#{note_body}</en-note>"

    # Create note object
    # parent_notebook is optional; if omitted, default notebook is used
    our_note         = Evernote::EDAM::Type::Note.new
    our_note.title   = note_title
    our_note.content = n_body
    if parent_notebook && parent_notebook.guid
      our_note.notebookGuid = parent_notebook.guid
    end

    begin  # Attempt to create note in Evernote account
      note = note_store.createNote(our_note)
    rescue Evernote::EDAM::Error::EDAMUserException => edue  ## Something was wrong with the note data
      # See EDAMErrorCode enumeration for error code explanation
      # http://dev.evernote.com/documentation/reference/Errors.html#Enum_EDAMErrorCode
      puts " EDAMUserException:                 \n" +
           " > errorCode: #{edue.errorCode}     \n" +
           " > parameter: #{edue.parameter}       "
    rescue Evernote::EDAM::Error::EDAMNotFoundException => ednfe
      # Parent Notebook GUID doesn't correspond to an actual notebook
      puts "EDAMNotFoundException: Invalid parent notebook GUID"
    end

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
