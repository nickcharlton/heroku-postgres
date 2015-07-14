module Heroku
  module Postgres
    # Representation and handling of Database objects
    class Database < Resource
      attr_accessor :app, :db
      attr_accessor :database_name, :database_user, :database_password,
                    :resource_url

      def self.find(app_name, db_name)
        response = Postgres.pg_client.get("/databases/#{db_name}")

        db = new(JSON.parse(response.body))

        db.db = db_name
        db.app = app_name

        db
      end

      def backups
        Backup.all_for_app(app)
      end
    end
  end
end
