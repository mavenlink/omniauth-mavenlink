require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mavenlink < OmniAuth::Strategies::OAuth2
      option :name, 'mavenlink'

      option :client_options, :site          => 'https://app.mavenlink.com',
                              :authorize_url => 'https://app.mavenlink.com/oauth/authorize?response_type=code',
                              :token_url     => 'https://app.mavenlink.com/oauth/token',
                              :api_url       => 'https://api.mavenlink.com/api/v1'

      option :token_params, :grant_type => 'authorization_code'

      uid { parsed_info['id'].to_s }

      info do
        {
          :name               => parsed_info['full_name'],
          :email              => parsed_info['email_address'],
          :headline           => parsed_info['headline'],
          :account_id         => parsed_info['account_id'].to_s,
          :plan_type          => parsed_info['plan_type'],
          :account_permission => parsed_info['account_permission'],
          :photo_path         => parsed_info['photo_path']
        }
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= access_token.get("#{options[:client_options][:api_url]}/users/me.json").parsed
      end

      def parsed_info
        @parsed_info = raw_info['users'].values.first
      end
    end
  end
end
