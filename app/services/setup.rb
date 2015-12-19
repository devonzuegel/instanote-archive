class Setup
  def self.steps(user)
    [
      {
        done:   !!user,
        phrase: 'Sign up',
        url:    '/signin'
      }, {
        done:   user && user.evernote_connected?,
        phrase: 'Connect Evernote',
        url:    '/evernote/connect'
      }, {
        done:   user && user.instapaper_connected?,
        phrase: 'Connect Instapaper',
        url:    '#'
      }, {
        phrase: 'Read!',
        url:    'http://instapaper.com'
      }
    ]
  end

  # - if user_signed_in?
  #
end
