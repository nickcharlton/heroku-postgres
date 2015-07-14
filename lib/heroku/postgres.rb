require 'excon'
require 'json'
require 'base64'

require 'heroku/postgres/version'
require 'heroku/postgres/client'
require 'heroku/postgres/resource'

# A container for Heroku extensions.
module Heroku
  # A container for Postgres.
  module Postgres
    attr_accessor :client

    # Login to Heroku Postgres.
    def self.login(username, password)
      @client = Client.new(username: username, password: password)
      @client.login

      @client
    end
  end
end
