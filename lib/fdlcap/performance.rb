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
    
    task :test_search, :roles => :app do
      url = "/vehicles/search?search[zip]=06108&search[radius]=10+Miles&search[view_type]=block&search[per_page]=10&search[year_from]=From+Year&search[year_to]=To+Year&search[model]=Model&search[price]=Price&search[color]=Color&search[mileage]=Mileage&commit=Search"
      run "/usr/local/bin/autobench --single_host --host1=audivehiclesearch.com --uri1=#{url} --file=/tmp/test_search.bench.txt --low_rate=1 --high_rate=20 --rate_step=2 --num_call=2 --num_conn=200"
      download "/tmp/test_search.bench.txt", "autobench/test_search.bench.txt", :via => :scp
      run "rm /tmp/test_search.bench.txt"
    end
    
  end

end