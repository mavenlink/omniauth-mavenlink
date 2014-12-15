require 'omniauth-oauth2'

module OmniAuth
  module Strategies
  	class Mavenlink < OmniAuth::Strategies::OAuth2
  		
      option :name, 'mavenlink'

      option :client_options, {
  			site: 'https://app.mavenlink.com',
  			authorize_url: 'https://app.mavenlink.com/oauth/authorize?response_type=code',
  			token_url: 'https://app.mavenlink.com/oauth/token'
  		}

      option :token_params, {
        grant_type: 'authorization_code',
      }

	    uid { raw_info['id'].to_s }

	    info do {
        	:name => raw_info['users']['full_name'],
        	:email => raw_info['users']['email_address']
          # name: raw_info
        }
    	end

    	extra do {
        	'raw_info' => raw_info
    	  }
    	end

    	def raw_info
    		@raw_info ||= access_token.get('https://api.mavenlink.com/api/v1/users/me.json').parsed
    	end

  	end
  end
end

