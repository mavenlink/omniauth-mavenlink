require 'omniauth-oauth2'

module OmniAuth
  module Strategies
  	class Mavenlink < OmniAuth::Strategies::OAuth2
  		option :client_options, {
  			site: 'https://app.mavenlink.com',
  			authorize_url: 'https://app.mavenlink.com/oauth/authorize',
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
        	:name => raw_info['full_name'],
        	:email => raw_info['email_address']
        }
    	end

    	extra do {
        	'raw_info' => raw_info
    	  }
    	end

    	def raw_info
    		@raw_info ||= access_token.get('https://api.mavenlink.com/api/v1/users/me.json').parsed
    	end


      def custom_build_access_token
        if request.xhr? && request.params['code']
          verifier = request.params['code']
          client.auth_code.get_token(verifier, { :redirect_uri => '/sessions/new'}.merge(token_params.to_hash(:symbolize_keys => true)),
                                     deep_symbolize(options.auth_token_params || {}))
        # elsif verify_token(request.params['id_token'], request.params['access_token'])
        elsif request.params['id_token'] && request.params['access_token']
          ::OAuth2::AccessToken.from_hash(client, request.params.dup)
        else
          orig_build_access_token
        end
      end
      alias_method :orig_build_access_token, :build_access_token
      alias_method :build_access_token, :custom_build_access_token


  	end
  end
end

