require 'omniauth-oauth2'

module OmniAuth
  module Strategies
  	class Mavenlink < OmniAuth::Strategies::OAuth2
  		option :client_options, {
  			site: 'https://app.mavenlink.com',
  			authorize_url: 'https://api.mavenlink.com/api/v1/oauth/authorize',
  			token_url: 'https://app.mavenlink.com/oauth/token'
  		}

  		def request_phase
        	super
	    end
	      
	    def authorize_params
	    	super.tap do |params|
	        	%w[scope client_options].each do |v|
		            if request.params[v]
		              params[v.to_sym] = request.params[v]
		            end
	        	end
	        end
	    end

	    uid { raw_info['id'].to_s }

	    info do {
        	:name => raw_info['name'],
        	:email => raw_info['email']
        }
    	end

    	extra do {
        	'raw_info' => raw_info
    	  }
    	end

    	def raw_info
    		@raw_info ||= access_token.get('/me').parsed
    	end

  	end
  end
end

