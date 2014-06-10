# MusicGlue::Tyson

![Mike Tyson](http://i.telegraph.co.uk/multimedia/archive/02362/mike-tyson_1_2362178b.jpg)

## Installation Instructions

Stick this in your rails `application.rb` pipe and smoke it

```ruby
config.middleware.insert_after ActionDispatch::Flash, ::MusicGlue::Tyson,
        oauth: { id: ENV['OAUTH_ID'], secret: ENV['OAUTH_SECRET'], oauth_options: { provider_ignores_state: true } }
```

The two ENV params you will have to get from the user-accounts application, by setting up a new application /oauth/applications

Only MG employees will have access to that endpoint.

## Usage

Tyson provides a `MusicGlue::Tyson::User` instance after it retrieves some basic credentials from the api in the `env['warden'].user` variable. It's up to you to decide how you want to decorate this. Either bind it to a local represetnation in your own database with permissions etc, or just use it as is.

## TODO

 - Logout
 - SSO Log Out

