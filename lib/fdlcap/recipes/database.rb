Capistrano::Configuration.instance(:must_exist).load do
  set(:create_database_on_cold, true)   

  set(:copy_compression, :gzip) 

  set(:exclude_tables, [])

  # Returns the file extension used for the compression method in
  # question.
  def compression_extension
    case copy_compression
    when :gzip, :gz   then "tar.gz"
    when :bzip2, :bz2 then "tar.bz2"
    when :zip         then "zip"
    else raise ArgumentError, "invalid compression type #{compression.inspect}"
    end
  end

  # Returns the command necessary to compress the given directory
  # into the given file. The command is returned as an array, where
  # the first element is the utility to be used to perform the compression.
  def compress(directory, file)
    case copy_compression
    when :gzip, :gz   then ["tar", "czf", file, directory]
    when :bzip2, :bz2 then ["tar", "cjf", file, directory]
    when :zip         then ["zip", "-qr", file, directory]
    else raise ArgumentError, "invalid compression type #{copy_compression.inspect}"
    end
  end

  # Returns the command necessary to decompress the given file,
  # relative to the current working directory. It must also
  # preserve the directory structure in the file. The command is returned
  # as an array, where the first element is the utility to be used to
  # perform the decompression.
  def decompress(file)
    case copy_compression
    when :gzip, :gz   then ["tar", "xzf", file]
    when :bzip2, :bz2 then ["tar", "xjf", file]
    when :zip         then ["unzip", "-q", file]
    else raise ArgumentError, "invalid compression type #{copy_compression.inspect}"
    end
  end 

  class Capistrano::Configuration
    def execute(command, failure_message = "Command failed")
      puts "Executing: #{command}"
      system(command) || raise(failure_message)
    end
  end

  namespace :database do
    desc <<-DESC
    create the production database
    DESC
    task :create, :roles => :db do
      run "cd #{current_path} && rake db:create RAILS_ENV=#{rails_env} --trace"
    end

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

    # ganked from pivotal
    desc "Pull db locally"
    task :pull_db_locally, :roles => :db do
      all_db_info = YAML.load(File.read("config/database.yml"))
      db_info = all_db_info[rails_env.to_s]
      raise "Missing database.yml entry for #{rails_env.to_s}" unless db_info

      database = db_info["database"]
      tables = ENV['TABLES'] ? ENV['TABLES'].split(',').join(' ') : ''
      dump_file = "/tmp/#{database}.sql"
      
      # look to see if a mysqldump process is already running
      run "ps aux | grep mysqldump | wc -l" do |channel, stream, data|
        puts data.strip.to_i
        if data.strip.to_i > 1
          puts "It appears that mysqldump is already running on the server - is another pull task being run?  Aborting to avoid clobbering the dumpfile."
          exit 1
        end
      end

      db_dump_found = false
      run "if [ -f #{dump_file}.gz ]; then echo exists; else echo not_found; fi" do |channel, stream, data|
        puts "Result: #{channel[:server]} -> #{dump_file}.gz ( #{data} )"
        db_dump_found = data.strip == 'exists' ? true : false
        break if stream == :err
      end

      db_host = db_info["host"]
      host = ""
      host_arg = " -h #{db_host}" if db_host
      db_dump_cmd = "mysqldump -e -q --single-transaction \
        -u #{db_info["username"]} --password=#{db_info["password"]} \
         #{host_arg} #{db_info["database"]} #{tables} | gzip > #{dump_file}.gz"

      if db_dump_found
        run "ls -l #{dump_file}.gz"
        puts %{
          ! INFO !: The remote database dump '#{dump_file}.gz' already exists

          If you would like to use the existing database dump type "USE EXISTING":
        }

        if ($stdin.gets.strip != "USE EXISTING")
          puts "Ignoring existing file and regenerating #{dump_file}.gz"
          run db_dump_cmd
        else
          puts "You confirmed that you want to use the existing file [#{dump_file}.gz], here we go"
        end
      else
        run db_dump_cmd
      end

      get "#{dump_file}.gz", "#{dump_file}.gz"
      run "rm #{dump_file}.gz" unless ENV['LEAVE_ON_SERVER']

      target_env = ENV['LOCAL_ENV'] || "development"
      target_db_info = all_db_info[target_env]
      target_db_login = "-u #{target_db_info["username"]} --password=#{target_db_info["password"]}"
      target_db_login += " -h #{target_db_info["host"]}" if target_db_info["host"]

      gunzip_cmd = "gunzip -c #{dump_file}.gz"
      sed_cmd = "sed 's/#{db_info["database"]}/#{target_db_info["database"]}/g' > #{dump_file}"
      execute("#{gunzip_cmd} | #{sed_cmd}", "gunzip/sed of #{dump_file}.gz failed")
      unless ENV['TABLES']
        execute("mysqladmin #{target_db_login} drop #{target_db_info["database"]} -f", "mysqladmin drop failed")
        execute("mysqladmin #{target_db_login} create #{target_db_info["database"]}", "mysqladmin create failed")
      end
      execute("mysql #{target_db_login} --database #{target_db_info["database"]} < #{dump_file}", "mysql import failed")
      execute("rake db:migrate RAILS_ENV=#{target_env}", "migrate failed")
      execute("rm #{dump_file}", "rm of local unzipped #{dump_file} failed")
    end
  end

  namespace :deploy do
    task :cold do
      update
      database.create if create_database_on_cold
      migrate
      start
    end
  end
end
