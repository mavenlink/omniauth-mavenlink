require 'omniauth-oauth2'
require 'json'

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
        	:name => raw_info['users']['5207615']['full_name'],
        	:email => raw_info['email_address'],
          :plan_type => raw_info['users']['plan_type'],
          :account_permission => raw_info['users']['account_permission']
          # name: raw_info
        }
    	end

    	extra do {
        	'raw_info' => raw_info
    	  }
    	end

    	def raw_info
    		# @raw_info ||= access_token.get('https://api.mavenlink.com/api/v1/users/me.json').parsed
        parse = JSON.parse(access_token.get('https://api.mavenlink.com/api/v1/users/me.json'))
        @raw_info ||= parse['users'].values.first
    	end

      # def user_id
      #   @user_id = raw_info['results']['id']
      # end

  	end
  end
end

