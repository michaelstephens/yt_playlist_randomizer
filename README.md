# yt_playlist_randomizer
 
A helpful script to randomize a youtube playlist!

## How to Run
* `cp .env.sample .env`
* Fill in values
* `bundle install`
* `ruby yt_playlist_randomizer.rb`

## Getting Authorization Code
You'll need to set up a OAuth 2 client with google: https://console.developers.google.com/
Once you have that set up with a proper redirect (localhost works), you can copy the `code` portion of the redirect url and input that to get the Auth Code.
