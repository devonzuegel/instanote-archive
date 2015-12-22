require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  BMK_OBJ = {
    'description':        '',
    'bookmark_id':        669020157,
    'title':              'Archipelago and Atomic Communitarianism',
    'url':                'http://slatestarcodex.com/2014/06/07/archipelago-and-atomic-communitarianism/',
    'progress_timestamp': Faker::Time.between(DateTime.now - 1, DateTime.now),
    'time':               Faker::Time.between(DateTime.now - 1, DateTime.now),
    'progress':           0.860173,
    'starred':            '1',
    'body':               Faker::Lorem.paragraph
  }

  before(:all) do
    @user = FactoryGirl.create(:user)
  end

  it 'create basic bookmark from a bookmark object' do
    Instapaper::Client.any_instance.stub(:verify_credentials).and_return(true)
    Instapaper::Client.any_instance.stub(:get_text).and_return(Faker::Lorem.paragraph)
    Instapaper::Client.any_instance.stub(:highlights).and_return(Faker::Lorem.sentences.map { |s| { text:s } })

    instapaper_account = FactoryGirl.create(:instapaper_account, user: @user)

    expect { Bookmark.create_from_bookmark(BMK_OBJ, @user) }.to change { Bookmark.count }.by 1
  end

  it 'create basic bookmark from a bookmark object without highlights' do
    Instapaper::Client.any_instance.stub(:verify_credentials).and_return(true)
    Instapaper::Client.any_instance.stub(:get_text).and_return(BMK_OBJ['body'])
    Instapaper::Client.any_instance.stub(:highlights).and_return([])

    instapaper_account = FactoryGirl.create(:instapaper_account, user: @user)
    bookmark = Bookmark.create_from_bookmark(BMK_OBJ, @user)

    expect(bookmark.description).to eq        BMK_OBJ['description']
    expect(bookmark.bookmark_id).to eq        BMK_OBJ['bookmark_id']
    expect(bookmark.title).to eq              BMK_OBJ['title']
    expect(bookmark.url).to eq                BMK_OBJ['url']
    expect(bookmark.progress_timestamp).to eq BMK_OBJ['progress_timestamp']
    expect(bookmark.progress).to eq           BMK_OBJ['progress']
    expect(bookmark.starred).to eq            (BMK_OBJ['starred'] == '1') ? true : false
    expect(bookmark.body).to eq               BMK_OBJ['body']
    expect(bookmark.user).to eq               @user
  end

  it 'shouldn\'t be stored to Evernote yet' do
    bookmark = FactoryGirl.create(:bookmark, user: @user)
    expect(bookmark.stored_to_evernote?).to be false
  end

  it 'should only allow us to have one bookmark with a given id for a particular user' do
    bid = 1234
    Bookmark.create(bookmark_id: bid, user: @user)
    expect(Bookmark.count).to eq 1
    expect { Bookmark.create(bookmark_id: bid, user: @user) }.to change { Bookmark.count }.by 0
  end

  it 'should allow us to create multiple bookmarks with the same id for different users' do
    bid = 1234
    user2 = FactoryGirl.create(:user)
    Bookmark.create(bookmark_id: bid, user: @user)
    expect(Bookmark.count).to eq 1
    expect { Bookmark.create(bookmark_id: bid, user: user2) }.to change { Bookmark.count }.by 1
  end

  it 'create basic bookmark from a bookmark object with highlights'
  it 'should store to Evernote and update status'
end
