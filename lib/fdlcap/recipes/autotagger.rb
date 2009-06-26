Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :release_tagger do
    # Set up some default stages
    set :autotagger_stages, [ :ci, :staging, :production ] unless exists?(:autotagger_stages)
    
    # This needs to be loaded after the stages are set up
    require 'release_tagger'
    
    # Run release tagger to get the right release for the deploy
    before  "deploy:update_code",      "release_tagger:set_branch"
    before  "deploy:cleanup",          "release_tagger:create_tag"
    before  "deploy:cleanup",          "release_tagger:write_tag_to_shared"
    before  "deploy:cleanup",          "release_tagger:print_latest_tags"
  end
end