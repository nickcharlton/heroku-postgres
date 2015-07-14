require 'excon'
require 'json'
require 'base64'

require 'heroku/postgres/version'
require 'heroku/postgres/client'
require 'heroku/postgres/resource'
require 'heroku/postgres/backup'
require 'heroku/postgres/database'

# A container for Heroku extensions.
module Heroku
  # A container for Postgres.
  module Postgres
    attr_accessor :client, :pg_client

    def self.client
      @client
    end

    def self.pg_client
      @pg_client
    end

    # Login to Heroku Postgres.
    #
    # This also configures the clients for both of the APIs we're talking to.
    def self.login(username, password)
      @client = Client.new(username: username, password: password)
      @client.login

      # setup the Heroku Postgres client
      @pg_client = Client.new(url: 'https://postgres-api.heroku.com',
                              username: username, password: password)
      @pg_client.token = @client.token

      @client
    end

    # A shortcut for finding databases.
    def self.find(app_name, db_name)
      Database.find(app_name, db_name)
    end
  end
end
