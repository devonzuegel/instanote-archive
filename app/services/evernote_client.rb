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
    notes = note_guids.map { |guid| find_note_by_guid(guid) }
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
      includeTitle: true,
      includeContentLength: true,
      includeCreated: true,
      includeUpdated: true,
      includeDeleted: true,
    )
  end
end
