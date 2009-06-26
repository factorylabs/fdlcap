Capistrano::Configuration.instance(:must_exist).load do
  
  define_recipe :nginx do
    #
    # Configuration
    #
  
    # global vars
    set :can_configure_nginx,   true
    set :nginx_user,            'nginx'
    set :nginx_processes,       4
    set :nginx_gzip_on,         true
    set :nginx_gzip_xml_on,     false

    # app specific vars
    set :nginx_server_names,    "_"
    set :nginx_far_future,      false
    set :nginx_default_app,     true

    # http auth vars
    set :nginx_auth_ip_masks,   ['192.168.0.0/254']
    set :nginx_http_auth_app,   false
    set :nginx_auth_locations,  []
    set :nginx_http_auth_users, []

    #
    # Tasks
    #

    namespace :nginx do

      %w( start stop restart reload ).each do |cmd|
        desc "#{cmd} your nginx servers"
        task "#{cmd}".to_sym, :roles => :web do
          default_run_options[:pty] = true 
          sudo "/etc/init.d/nginx #{cmd}"
        end
      end
  
      desc "Setup Nginx vhost config"
      task :vhost, :roles => :web do
        result = render_erb_template(File.dirname(__FILE__) + "/templates/nginx.vhost.conf.erb")
        put result, "/tmp/nginx.vhost.conf"
        sudo "mkdir -p /etc/nginx/vhosts"
        sudo "cp /tmp/nginx.vhost.conf /etc/nginx/vhosts/#{application}.conf"
        inform "You must edit nginx.conf to include the vhost config file."
      end
  
      desc "Setup Nginx vhost auth config"
      task :vhost_auth, :roles => :web do
        result = render_erb_template(File.dirname(__FILE__) + "/templates/nginx.auth.conf.erb")
        put result, "/tmp/nginx.auth.conf"
        sudo "mkdir -p /etc/nginx/vhosts"
        sudo "cp /tmp/nginx.vhost.conf /etc/nginx/vhosts/#{application}.auth.conf"
      end
  
      desc "Setup htpasswd file for nginx auth"
      task  :create_htpasswd, :roles => :web do
        sudo "mkdir -p /etc/nginx/conf"
        for user in nginx_http_auth_users
          run "cd /etc/nginx/conf && htpasswd -b htpasswd #{user['name']} #{user['password']}"
          # run <<-CMD
          #       cd /etc/nginx/conf;
          #       if [ ! -e /etc/nginx/conf/htpasswd ] ; then
          #           htpasswd -b -c htpasswd #{user['name']} #{user['password']};
          #       else
          #           htpasswd -b htpasswd #{user['name']} #{user['password']};
          #       fi
          #       CMD
        end
      end
  
      desc "Setup Nginx.config"
      task :conf, :roles => :web do
        if can_configure_nginx
      
          result = render_erb_template(File.dirname(__FILE__) + "/templates/nginx.conf.erb")
          put result, "/tmp/nginx.conf"
          sudo "cp /tmp/nginx.conf /etc/nginx/nginx.conf"
      
        else
          inform "Nginx configuration tasks have been disabled. Most likely you are deploying to engineyard which has it's own nginx conf setup."
        end
      end
  
      desc "Setup Nginx vhost config and nginx.conf"
      task :configure, :roles => :web do
        if can_configure_nginx
      
          conf
          vhost
          vhost_auth      if nginx_auth_locations.length > 0 || nginx_http_auth_app
          create_htpasswd if nginx_http_auth_users.length > 0
      
        else
          inform "Nginx configuration tasks have been disabled. Most likely you are deploying to engineyard which has it's own nginx conf setup."
        end
      end

    end
  end
end