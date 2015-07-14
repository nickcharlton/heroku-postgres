module Heroku
  module Postgres
    # Representation and handling of Database objects
    class Database < Resource
      attr_accessor :name, :app
      attr_accessor :database_name, :database_user, :database_password,
                    :resource_url

      def self.find(app_name, db_name)
        response = Postgres.pg_client.get("/databases/#{db_name}")

        db = new(JSON.parse(response.body))

        db.name = db_name
        db.app = app_name

        db
      end
    end
  end
end
