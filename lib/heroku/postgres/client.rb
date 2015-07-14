module Heroku
  module Postgres
    # Client for interacting with Heroku & Heroku's Postgres API.
    class Client
      DEFAULT_HEADERS = { 'User-Agent' => 'Heroku-Postgres/v' \
                                          "#{Heroku::Postgres::VERSION}" }

      attr_accessor :url, :username, :password, :token

      def initialize(opts = {})
        @url = opts.fetch(:url, 'https://api.heroku.com')
        @username = opts.fetch(:username, {})
        @password = opts.fetch(:password, {})
      end

      # Login on behalf of the user.
      #
      # This is necessary to setup the class correctly so that the API key can
      # be used.
      #
      # @return [String] the Heroku API key
      def login
        response = login_request(username, password)

        hash = JSON.parse(response.body)
        @token = hash['api_key']
      end

      %w(get post put delete).each do |m|
        define_method m do |path, opts = {}|
          request(m.to_sym, path, opts)
        end
      end

      private

      def login_request(username, password)
        Excon.post('https://api.heroku.com/login',
                   headers: DEFAULT_HEADERS,
                   query: { username: username, password: password },
                   expects: [200])
      end

      def request(method, path, opts = {})
        body, query, headers = parse_opts(opts)

        # set the default headers
        headers.merge!(DEFAULT_HEADERS)

        # set the authentication header
        headers['Authorization'] = "Basic #{authentication_header}"

        connection = Excon.new(@url)
        connection.request(method: method, path: "/client/v11#{path}",
                           body: body, query: query, headers: headers)
      end

      def parse_opts(opts)
        # this might actually want to be a form
        body = opts.fetch(:body, nil)
        body = JSON.dump(body) if body && body.is_a?(Hash)

        query = opts.fetch(:query, {})
        headers = opts.fetch(:headers, {})

        [body, query, headers]
      end

      def authentication_header
        Base64.urlsafe_encode64("#{@username}:#{@token}")
      end
    end
  end
end
