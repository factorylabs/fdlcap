Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :release_tagger do |*stages|
    # Set up some default stages
    set :autotagger_stages, stages.flatten unless exists?(:autotagger_stages)  && !stages.empty?
    
    # This needs to be loaded after the stages are set up
    require 'auto_tagger/recipes'
    
    set :keep_release_tags, 5 unless exists?(:keep_release_tags)
    namespace :release_tagger do
      desc "remove old tags, similar to keep_releases"
      task :remove_previous_tags, :roles => :app do
        keep_tags = fetch(:keep_release_tags, 5)
        tags = `git tag`
        tags = tags.split
        stage_tags = {}
        tags.each do |tag|
          stage = tag.split('/').first
          stage_tags[stage] = [] unless stage_tags.key?(stage)
          stage_tags[stage] << tag
        end

        stage_tags.each do |stage, tags|
          # remove all tags but the last n number
          tags[0..-(keep_tags + 1)].each do |tag|
            puts `git tag -d #{tag}`
            puts `git push origin :refs/tags/#{tag}`
          end
        end
      end
      
      desc "remove all local stage tags before release_tagger fetches all tags"
      task :remove_local_stage_tags, :roles => :app do
        autotagger_stages.each do |stage|
          puts `git tag -l #{stage}/* | xargs git tag -d` 
        end if fetch(:perform_remove_local_stage_tags, true)
      end
    end
    
    # Run release tagger to get the right release for the deploy
    before  "deploy:update_code", "release_tagger:remove_local_stage_tags"
    before  "deploy:update_code", "release_tagger:set_branch"
    
    before  "deploy:cleanup",     "release_tagger:create_tag"
    before  "deploy:cleanup",     "release_tagger:write_tag_to_shared"
    before  "deploy:cleanup",     "release_tagger:remove_previous_tags"
    before  "deploy:cleanup",     "release_tagger:print_latest_tags"
    
    
  end
end