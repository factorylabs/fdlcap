Capistrano::Configuration.instance(:must_exist).load do
  # Run autotagger to get the right release
  if exists?(:use_release_tagger)
    before  "deploy:update_code",      "release_tagger:set_branch"
    before  "deploy:cleanup",          "release_tagger:create_tag"
    before  "deploy:cleanup",          "release_tagger:write_tag_to_shared"
    before  "deploy:cleanup",          "release_tagger:print_latest_tags"
  end
end