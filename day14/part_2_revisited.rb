# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read

class Recipe
  attr_accessor :ingredients, :result, :quantity_used, :quantity_disponible, :possible_to_make

  def initialize(ingredients, result)
    @ingredients, @result = ingredients, result
    @quantity_used = 0
    @quantity_disponible = result[:material] == "ORE" ? 1_000_000_000_000 : 0
    @possible_to_make = result[:material] == "ORE" ? false : true
  end

  def make(recipes, quantity_required)
    if quantity_required > quantity_disponible && !possible_to_make
      return 0
    end

    if possible_to_make
      while quantity_disponible < quantity_required
        ingredients.each do |ingredient|
          recipe = recipes.find { |recipe| recipe.result[:material] == ingredient[:material] }

          if recipe.make(recipes, ingredient[:quantity]) == 0
            @possible_to_make = false
            return 0
          end
        end

        @quantity_disponible = @quantity_disponible + result[:quantity]
      end
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
ore_per_fuel = recipes.find { |recipe| recipe.result[:material] == "ORE" }.quantity_used

ore_remaining = 1_000_000_000_000
minimum_quantity = ore_remaining / ore_per_fuel

recipes.map do |recipe|
  recipe.quantity_used = recipe.quantity_used * minimum_quantity
  recipe.quantity_disponible = recipe.quantity_disponible * minimum_quantity
end

recipes.find { |recipe| recipe.result[:material] == "ORE" }.quantity_disponible = ore_remaining - (ore_per_fuel * minimum_quantity)

last_fuel_quantity = 0
increment = 1

while increment > 0
  last_fuel_quantity = recipes.find { |recipe| recipe.result[:material] == "FUEL" }.quantity_used
  make_material("FUEL", increment, recipes)
  print recipes.map { |recipe| recipe.quantity_disponible }.join(',')
  if last_fuel_quantity == recipes.find { |recipe| recipe.result[:material] == "FUEL" }.quantity_used
    increment -= 1
  else
    increment += 2
  end

  puts "   last_fuel = #{last_fuel_quantity}"
end

binding.pry

pp recipes.find { |recipe| recipe.result[:material] == "ORE" }.quantity_used



puts ( 1000000000000 / one_fuel ) * (1000000000000 / calculate_ore(1000000000000 / one_fuel))
