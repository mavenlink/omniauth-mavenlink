# Omniauth Mavenlink

This is an OmniAuth strategy for authenticating to Mavenlink. To use it, you will need to add an OAuth2 application in Mavenlink and have the Client ID and Client Secret.

For more information about the Mavenlink API: http://developer.mavenlink.com/

## Basic Usage

If you are using Rails, add the gem to your `Gemfile`:
  
  gem 'omniauth-mavenlink'

Once installed, add the following to `config/initializers/omniauth.rb`:

  use OmniAuth::Builder do
    provider :mavenlink, ENV['MAVENLINK_KEY'], ENV['MAVENLINK_SECRET']
  end


