Capistrano::Configuration.instance(:must_exist).load do
  namespace :autoperf do
    desc "get nginx log for load test"
    task :fetch_log, :roles => :app do
      # Grab the last 1000 requests from production Nginx log, and extract the request path (ex: /index)
      run "tail -n 1000 /var/log/nginx/#{application}.access.log | awk '{print $7}' > /tmp/requests.log"

      # Replace newlines with null terminator (httperf format)
      run 'tr "\n" "\0" < /tmp/requests.log > /tmp/requests_httperf.log'
      
      download "/tmp/requests_httperf.log", "config/autoperf/requests_httperf.log", :via => :scp
      
      run "rm /tmp/requests_httperf.log"
    end
    
    task :run_test, :roles => :app do
      run "cd #{current_path} && script/autoperf -c config/autoperf/primary.conf" do |channel, stream, data|
        puts data if stream == :out
        if stream == :err
          puts "[Error: #{channel[:host]}] #{data}"
          break
        end
      end
    end
  end
  
  namespace :autobench do
    
    task :run_test, :roles => :app do
      options = ENV['OPTIONS'] || "--low_rate=1 --high_rate=20 --rate_step=2 --num_call=2 --num_conn=200"
      run "/usr/local/bin/autobench --single_host --host1=#{ENV['HOST']} --uri1=#{ENV['URL']} --file=/tmp/test.bench.txt #{options}"
      download "/tmp/test.bench.txt", "autobench/test.bench.txt", :via => :scp
      run "rm /tmp/test.bench.txt"
    end
    
  end
  
  namespace :install do

    task :setup do
      sudo "rm -rf src"
      run  "mkdir -p src"
    end

    desc "Install httperf"
    task :httperf do
      setup

      cmd = [
        "cd src",
        "wget ftp://ftp.hpl.hp.com/pub/httperf/httperf-0.9.0.tar.gz",
        "tar xfz httperf-0.9.0.tar.gz",
        "cd httperf-0.9.0",
        "./configure --prefix=/usr/local",
        "make", 
        "sudo make install"
        ].join(' && ')
        run cmd
        run 'rm httperf-0.9.0.tar.gz'
    end

    task :autobench do
      setup

      cmd = [
        "cd src",
        "wget http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz",
        "tar xfz autobench-2.1.2.tar.gz",
        "cd autobench-2.1.2",
        "make", 
        "sudo make install"
        ].join(' && ')
        run cmd
        run 'rm autobench-2.1.2.tar.gz'
    end
  end

end