Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :stages do |*stages|
    
    set :stages, stages.flatten unless exists?(:stages) && !stages.empty?
    
    unless exists?(:default_stage)
      set :default_stage,     :staging
    end
    
    require 'capistrano/ext/multistage'
  end
end