Capistrano::Configuration.instance(:must_exist).load do
  namespace :database do
    desc "Push db remotely"
    task :push_db_remotely, :roles => :db do

      default_character_set = Object.const_defined?(:DEFAULT_CHARACTER_SET) ? Object::DEFAULT_CHARACTER_SET : "utf8"

      local_env = ENV['LOCAL_ENV'] || "development"

      all_db_info = YAML.load(File.read("config/database.yml"))
      local_db_info = all_db_info[local_env]
      remote_db_info = all_db_info[rails_env.to_s]
      raise "Missing database.yml entry for #{local_env}" unless local_db_info
      raise "Missing database.yml entry for #{rails_env.to_s}" unless remote_db_info


      puts %{

        ! WARNING !: The remote database '#{remote_db_info["database"]}'
        will be replaced with the contents of the local database '#{local_db_info["database"]}'.  
        A dump of the remote db will be placed in your remote home directory just prior 
        to it being replaced.

        1) current REMOTE_DB ===> backed up to dump file, in ~/
        2) LOCAL_DB ===> REMOTE_DB ...old REMOTE_DB contents are overwritten!!!

        Even so, this is a very significant and potentially destructive operation.  Please step
        back and contemplate what you're about to do.

        If you're really sure you want to continue, type "REPLACE #{remote_db_info["database"].upcase}":
      }

      if ($stdin.gets.strip != "REPLACE #{remote_db_info["database"].upcase}")
        puts "No action taken, exiting"
        exit(1)
      else
        puts "You confirmed that you want to continue, here we go"
      end

      dump_file_name = "#{local_db_info["database"]}.sql"
      local_dump_file_gz_path = "/tmp/#{dump_file_name}.gz"

      execute "time mysqldump -e -q --single-transaction --default_character_set=#{default_character_set} \
      -u #{local_db_info["username"]} --password=#{local_db_info["password"]} \
      --database #{local_db_info["database"]} | gzip > #{local_dump_file_gz_path}"

      upload "#{local_dump_file_gz_path}", "#{dump_file_name}.gz", :via => :scp
    
      execute "echo ^G^G^G^G^G"

      run "gzip -df ~/#{dump_file_name}.gz"
      run "perl -pi -e 's|#{local_db_info["database"]}|#{remote_db_info["database"]}|g' ~/#{dump_file_name}"

      run "time mysqldump -e -q --single-transaction  --default_character_set=#{default_character_set} \
      -u #{remote_db_info["username"]} --password=#{remote_db_info["password"]} \
      --database #{remote_db_info["database"]} | gzip > ~/#{remote_db_info["database"]}_#{Time.now.strftime("%Y-%m-%d_%H-%M-%S")}.sql.gz"

      remote_host = remote_db_info["host"] || "localhost"

      run "mysqladmin -u #{remote_db_info["username"]} --password=#{remote_db_info["password"]} -h #{remote_host} drop #{remote_db_info["database"]} -f"
      run "mysqladmin -u #{remote_db_info["username"]} --password=#{remote_db_info["password"]} -h #{remote_host} create #{remote_db_info["database"]} --default_character_set=#{default_character_set}"
      run "time mysql -u #{remote_db_info["username"]} --password=#{remote_db_info["password"]} -h #{remote_host} --database #{remote_db_info["database"]} --default_character_set=#{default_character_set} < ~/#{dump_file_name}"
      run "rm ~/#{dump_file_name}"

    end
  end
end
