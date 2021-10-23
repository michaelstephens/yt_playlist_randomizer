require 'rubygems'
require 'yt'
require 'launchy'
require 'httparty'
require 'progress_bar'
require 'dotenv'
require 'pry'

Dotenv.load

PLAYLIST_ID = ENV["PLAYLIST_ID"]
REDIRECT_URI = ENV["REDIRECT_URI"]
SCOPES = ENV["SCOPES"].split(',')
YOUTUBE_CLIENT_ID = ENV["YOUTUBE_CLIENT_ID"]
YOUTUBE_CLIENT_SECRET = ENV["YOUTUBE_CLIENT_SECRET"]

Yt.configure do |config|
  config.client_id = YOUTUBE_CLIENT_ID
  config.client_secret = YOUTUBE_CLIENT_SECRET
end

# Pretty print
puts "####################################"
puts 'Youtube Playlist Randomizer'
puts "####################################"
puts

# Authorize Account
url = Yt::Account.new(scopes: SCOPES, redirect_uri: REDIRECT_URI).authentication_url
Launchy.open url
puts "Please input the code below"
print "Code: "
authorization_code = CGI.unescape(gets.chomp)

response = HTTParty.post(
  'https://accounts.google.com/o/oauth2/token',
  body: {
    client_id: YOUTUBE_CLIENT_ID,
    client_secret: YOUTUBE_CLIENT_SECRET,
    grant_type: 'authorization_code',
    code: authorization_code,
    redirect_uri: REDIRECT_URI,
  },
  headers: {
    'Content-Type' => 'application/x-www-form-urlencoded'
  }
).parsed_response

# Load account
account = Yt::Account.new(access_token: response["access_token"])
puts
puts "####################################"
puts "[SUCCESS] Account loaded"
print 'Account Email: '
puts account.email
print 'Account Name: '
puts account.name
puts "####################################"
puts

# Get playlist
playlist = Yt::Playlist.new(id: PLAYLIST_ID, auth: account)
puts
puts "####################################"
puts "[SUCCESS] Playlist loaded"
print 'Playlist Title: '
puts playlist.title
print 'Playlist Description:'
puts playlist.description
puts "####################################"
puts

# Store Items in memory
playlist_item_ids = playlist.playlist_items.map(&:id)
# Set up Progress Bar
bar = ProgressBar.new(playlist_item_ids.count)

# Shuffle Playlist Items
puts "Shuffling Playlist Items"
playlist_item_ids.shuffle.each_with_index do |playlist_item_id, i|
  item = Yt::PlaylistItem.new(id: playlist_item_id, auth: account)
  item.update position: i
  bar.increment!
end
