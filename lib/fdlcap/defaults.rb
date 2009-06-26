Capistrano::Configuration.instance(:must_exist).load do
  
  # Set up default stages for capistano-ext-multistage
  unless exists?(:stages)
    set :stages,            [ :staging, :production ]
  end
  
  unless exists?(:default_stage)
    set :default_stage,     :staging
  end
  
end