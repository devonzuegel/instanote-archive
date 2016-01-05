desc 'This task is called by the Heroku scheduler add-on'
task :sync_bookmarks => :environment do
  puts 'Syncing bookmarks...'
  User.sync_bookmarks
  puts 'Done!'
end

task :test_note => :environment do
  puts 'Syncing a single test bookmark.'
  user = User.where(name: 'Devon Marisa Zuegel')
  user.save_test_bookmark!
  puts 'Saved a test bookmark to Devon\'s Evernote account.'
end
