desc 'This task is called by the Heroku scheduler add-on'
task :sync_bookmarks => :environment do
  puts 'Syncing bookmarks...'
  User.sync_bookmarks
  puts 'Done!'
end