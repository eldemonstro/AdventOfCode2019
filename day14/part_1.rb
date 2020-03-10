# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read

class Recipe
  attr_accessor :ingredients, :result, :quantity_used, :quantity_disponible

  def initialize(ingredients, result)
    @ingredients, @result = ingredients, result
    @quantity_used = 0
    @quantity_disponible = result[:material] == "ORE" ? Float::INFINITY : 0
  end

  def make(recipes, quantity_required)
    while quantity_disponible < quantity_required
      ingredients.each do |ingredient|
        recipe = recipes.find { |recipe| recipe.result[:material] == ingredient[:material] }

        recipe.make(recipes, ingredient[:quantity])
      end

      @quantity_disponible = @quantity_disponible + result[:quantity]
    end

    @quantity_disponible = @quantity_disponible - quantity_required
    @quantity_used = @quantity_used + quantity_required

    quantity_required
  end
end

def parse_recipe(recipe)
  ingredients_text, result_text = recipe.split(" => ")
  result = {
    quantity: result_text.split[0].to_i,
    material: result_text.split[1]
  }

  ingredients = ingredients_text.split(", ").map do |ingredient_text|
    {
      quantity: ingredient_text.split[0].to_i,
      material: ingredient_text.split[1]
    }
  end

  Recipe.new(ingredients, result)
end

def make_material(material, quantity, recipes)
  recipe = recipes.find { |recipe| recipe.result[:material] == material }

  quantity.times do
    recipe.make(recipes, quantity)
  end
end

recipes = []

text.split("\n") do |line|
  recipes.push parse_recipe(line)
end

# Ore responds with ore
recipes.push Recipe.new([{material: 'ORE', quantity: 1}], {material: 'ORE', quantity: 1})

make_material("FUEL", 1, recipes)

pp recipes.find { |recipe| recipe.result[:material] == "ORE" }.quantity_used
