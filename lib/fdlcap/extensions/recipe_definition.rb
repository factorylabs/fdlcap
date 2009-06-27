Capistrano::Configuration.instance(:must_exist).load do
  
  set :fdlcap_recipes, {}
  
  def define_recipe(name,&block)
    recipes = fetch(:fdlcap_recipes)
    recipes[name] = block
  end
  
  def use_recipe(recipe, *args)
    recipe_block = fetch(:fdlcap_recipes)[recipe]
    if recipe_block
      recipe_block.call(*args)
    else
      raise ArgumentError, "Recipe => :#{recipe} not found"
    end
  end
  
end