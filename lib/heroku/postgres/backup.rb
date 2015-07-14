module Heroku
  module Postgres
    # Representation and handling of Backup objects
    class Backup < Resource
      attr_accessor :app

      attr_accessor :uuid, :num, :from_name, :from_type, :from_url, :to_name,
                    :to_type, :to_url, :options, :source_bytes,
                    :processed_bytes, :succeeded, :created_at, :started_at,
                    :canceled_at, :updated_at, :finished_at, :deleted_at,
                    :purged_at, :num_keep

      def self.find(app_name, backup_name)
        response = Postgres.pg_client.get("/apps/#{app_name}/transfers/"\
                                          "#{backup_name}?verbose=true")

        backup = new(JSON.parse(response.body))
        backup.app = app_name

        backup
      end

      def self.all_for_app(app_name)
        response = Postgres.pg_client.get("/apps/#{app_name}/transfers")

        # build backup objects, but only those generated with pg_dump
        backups = JSON.parse(response.body).collect do |c|
          next if c['from_type'] != 'pg_dump'

          backup = new(c)
          backup.app = app_name

          backup
        end.compact!

        backups
      end

      # Generate a public URL for accessing this backup.
      def public_url
        response = Postgres.pg_client.post("/apps/#{app}/transfers/#{num}"\
                                           '/actions/public-url')

        hash = JSON.parse(response.body)
        hash['url']
      end
    end
  end
end
