Capistrano::Configuration.instance(:must_exist).load do
  
  set :fdlcap_recipes, {}
  
  def define_recipe(name,&block)
    recipes = fetch(:fdlcap_recipes)
    recipes[name] = block
  end
  
  def use_recipe(recipe)
    fetch(:fdlcap_recipes)[recipe].call
  end
  
end