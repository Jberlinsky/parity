require 'yaml'

module Parity
  class Backup
    def initialize(args)
      @from, @to = args.values_at(:from, :to)
    end

    def restore
      if to == 'development'
        restore_to_development
      else
        restore_to_pass_through
      end
    end

    private

    attr_reader :from, :to

    def restore_to_development
      Kernel.system "#{curl} | #{pg_restore}"
    end

    def curl
      "curl -s `#{db_backup_url}`"
    end

    def pg_restore
      "pg_restore --verbose --clean --no-acl --no-owner -d #{development_db}"
    end

    def restore_to_pass_through
      Kernel.system "hk pgbackups:restore #{backup_from} -a #{to}"
    end

    def backup_from
      "DATABASE `#{db_backup_url}`"
    end

    def db_backup_url
      "hk pgbackups:url -a #{from}"
    end

    def development_db
      yaml_file = IO.read(Parity.config.database_config_path)
      YAML.load(yaml_file)['development']['database']
    end
  end
end
